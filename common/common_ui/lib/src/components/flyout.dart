import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';

/// Defines the width behavior of the flyout.
enum UiFlyoutWidth {
  /// The flyout will hug the content regardless of the target.
  fixed,

  /// The flyout will match the target width.
  fill,
}

/// {@template ui_flyout_anchor}
/// Positioning configuration for a flyout with automatic overflow handling.
///
/// The flyout is positioned by aligning [flyoutAlignment] on the flyout
/// to [anchorAlignment] on the target widget, plus any [offset].
///
/// **Overflow behavior:**
/// 1. If the flyout overflows, it flips to the opposite side.
/// 2. If both sides overflow, it stays on the original side but shifts
///    to remain within bounds.
/// {@endtemplate}
@immutable
class UiFlyoutAnchor {
  /// {@macro ui_flyout_anchor}
  const UiFlyoutAnchor({
    this.offset = Offset.zero,
    this.anchorAlignment = AlignmentDirectional.bottomEnd,
    this.flyoutAlignment = AlignmentDirectional.topEnd,
  });

  /// The offset of the flyout from the anchor.
  final Offset offset;

  /// The point on the anchor to which the flyout is aligned.
  final AlignmentGeometry anchorAlignment;

  /// The point on the flyout that should be aligned with the anchor.
  final AlignmentGeometry flyoutAlignment;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UiFlyoutAnchor &&
        other.offset == offset &&
        other.anchorAlignment == anchorAlignment &&
        other.flyoutAlignment == flyoutAlignment;
  }

  @override
  int get hashCode => Object.hash(offset, anchorAlignment, flyoutAlignment);
}

/// {@template ui_flyout}
/// A low-level flyout widget that displays a pop-up connected to a target
/// element.
///
/// This is a headless building block designed to be reused by other components
/// (e.g., tooltips, dropdowns, popovers).
///
/// **What it provides:**
/// - Positioning math to anchor the flyout to a target widget
/// - Automatic overflow handling (flips to opposite side if needed)
/// - Scroll-aware repositioning when parent scrolls
///
/// **What it does NOT provide:**
/// - Focus management
/// - Semantics / accessibility
/// - Tap-outside dismissal
/// - Any UI or styling
///
/// See also:
/// - [UiFlyoutAnchor] for configuring flyout positioning and alignment.
/// {@endtemplate}
class UiFlyout extends StatefulWidget {
  /// {@macro ui_flyout}
  const UiFlyout({
    required this.isOpen,
    required this.flyoutBuilder,
    required this.child,
    this.anchor = const UiFlyoutAnchor(),
    this.width = UiFlyoutWidth.fixed,
    super.key,
  });

  /// The anchor of the flyout, which is used to position it.
  final UiFlyoutAnchor anchor;

  /// The width behavior of the flyout.
  final UiFlyoutWidth width;

  /// Whether the flyout is open.
  final bool isOpen;

  /// The builder for the flyout content.
  final WidgetBuilder flyoutBuilder;

  /// The target/anchor widget.
  final Widget child;

  @override
  State<UiFlyout> createState() => _UiFlyoutState();
}

class _UiFlyoutState extends State<UiFlyout> {
  late final OverlayPortalController _overlayPortalController;
  ScrollNotificationObserverState? _scrollNotificationObserver;

  @override
  void initState() {
    super.initState();
    _overlayPortalController = OverlayPortalController();
    _scheduleChangeVisibility();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateScrollObserver();
  }

  @override
  void didUpdateWidget(covariant UiFlyout oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.isOpen != widget.isOpen) {
      _scheduleChangeVisibility();
      _scheduleUpdateScrollObserver();
    }
  }

  @override
  void dispose() {
    _scrollNotificationObserver?.removeListener(_handleScrollNotification);
    super.dispose();
  }

  void _scheduleUpdateScrollObserver() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (mounted) _updateScrollObserver();
    });
  }

  void _updateScrollObserver() {
    _scrollNotificationObserver?.removeListener(_handleScrollNotification);
    _scrollNotificationObserver = ScrollNotificationObserver.maybeOf(context);

    if (widget.isOpen) {
      _scrollNotificationObserver?.addListener(_handleScrollNotification);
    }
  }

  void _handleScrollNotification(ScrollNotification notification) {
    if (!mounted || !widget.isOpen) return;

    if (notification is ScrollUpdateNotification &&
        defaultScrollNotificationPredicate(notification)) {
      setState(() {});
    }
  }

  /// Schedules the visibility change for the next frame.
  ///
  /// This is necessary because [OverlayPortal] does not allow toggling
  /// visibility during the same frame it is built.
  void _scheduleChangeVisibility() {
    final visibility = widget.isOpen;

    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      if (visibility) {
        _overlayPortalController.show();
      } else {
        _overlayPortalController.hide();
      }
    });
  }

  Widget _overlayChildBuilder(BuildContext flyoutContext) {
    return LayoutBuilder(
      builder: (_, constraints) {
        final direction = Directionality.of(context);
        final target = context.findRenderObject()! as RenderBox;
        final overlay = Overlay.of(flyoutContext).context.findRenderObject()! as RenderBox;

        final targetGlobalOffset = target.localToGlobal(Offset.zero);
        final targetInOverlay = overlay.globalToLocal(targetGlobalOffset);
        final targetRect = targetInOverlay & target.size;

        return CustomSingleChildLayout(
          delegate: _UiFlyoutDelegate(
            anchor: widget.anchor,
            targetRect: targetRect,
            direction: direction,
            width: widget.width,
          ),
          child: widget.flyoutBuilder(flyoutContext),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return OverlayPortal(
      controller: _overlayPortalController,
      overlayChildBuilder: _overlayChildBuilder,
      child: widget.child,
    );
  }
}

class _UiFlyoutDelegate extends SingleChildLayoutDelegate {
  _UiFlyoutDelegate({
    required this.anchor,
    required this.targetRect,
    required this.direction,
    required this.width,
  });

  final UiFlyoutAnchor anchor;
  final Rect targetRect;
  final TextDirection direction;
  final UiFlyoutWidth width;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    return switch (width) {
      UiFlyoutWidth.fixed => constraints.loosen(),
      UiFlyoutWidth.fill => BoxConstraints(
        minWidth: targetRect.width,
        maxWidth: targetRect.width,
        maxHeight: constraints.maxHeight,
      ),
    };
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    final anchorAlignment = anchor.anchorAlignment.resolve(direction);
    final flyoutAlignment = anchor.flyoutAlignment.resolve(direction);
    final offset = anchor.offset;

    var position = _calculatePosition(
      anchorAlignment: anchorAlignment,
      flyoutAlignment: flyoutAlignment,
      childSize: childSize,
      offset: offset,
    );
    position = _flipIfOverflowing(
      position: position,
      anchorAlignment: anchorAlignment,
      flyoutAlignment: flyoutAlignment,
      offset: offset,
      childSize: childSize,
      availableSize: size,
    );
    position = _clampToAvailableSpace(position, childSize, size);

    return position;
  }

  /// Tries flipping the flyout to the opposite side if it overflows.
  ///
  /// Only flips if the other side has no overflow; otherwise stays on the
  /// original side.
  Offset _flipIfOverflowing({
    required Offset position,
    required Alignment anchorAlignment,
    required Alignment flyoutAlignment,
    required Offset offset,
    required Size childSize,
    required Size availableSize,
  }) {
    final needsHorizontalFlip =
        position.dx < 0 || position.dx + childSize.width > availableSize.width;
    final needsVerticalFlip =
        position.dy < 0 || position.dy + childSize.height > availableSize.height;

    if (!needsHorizontalFlip && !needsVerticalFlip) return position;

    final flippedAnchorAlignment = Alignment(
      needsHorizontalFlip ? -anchorAlignment.x : anchorAlignment.x,
      needsVerticalFlip ? -anchorAlignment.y : anchorAlignment.y,
    );
    final flippedFlyoutAlignment = Alignment(
      needsHorizontalFlip ? -flyoutAlignment.x : flyoutAlignment.x,
      needsVerticalFlip ? -flyoutAlignment.y : flyoutAlignment.y,
    );
    final flippedOffset = Offset(
      needsHorizontalFlip ? -offset.dx : offset.dx,
      needsVerticalFlip ? -offset.dy : offset.dy,
    );

    final flippedPosition = _calculatePosition(
      anchorAlignment: flippedAnchorAlignment,
      flyoutAlignment: flippedFlyoutAlignment,
      childSize: childSize,
      offset: flippedOffset,
    );

    final flippedOverflow = _calculateOverflow(flippedPosition, childSize, availableSize);

    return flippedOverflow == 0 ? flippedPosition : position;
  }

  Offset _clampToAvailableSpace(
    Offset position,
    Size childSize,
    Size availableSize,
  ) {
    var dx = position.dx;
    var dy = position.dy;

    if (dx + childSize.width > availableSize.width) {
      dx = availableSize.width - childSize.width;
    }
    if (dx < 0) dx = 0;

    if (dy + childSize.height > availableSize.height) {
      dy = availableSize.height - childSize.height;
    }
    if (dy < 0) dy = 0;

    return Offset(dx, dy);
  }

  Offset _calculatePosition({
    required Alignment anchorAlignment,
    required Alignment flyoutAlignment,
    required Size childSize,
    required Offset offset,
  }) {
    final anchorPoint = Offset(
      targetRect.left + targetRect.width * ((anchorAlignment.x + 1) / 2),
      targetRect.top + targetRect.height * ((anchorAlignment.y + 1) / 2),
    );

    final flyoutPoint = Offset(
      childSize.width * ((flyoutAlignment.x + 1) / 2),
      childSize.height * ((flyoutAlignment.y + 1) / 2),
    );

    return anchorPoint - flyoutPoint + offset;
  }

  double _calculateOverflow(
    Offset position,
    Size childSize,
    Size availableSize,
  ) {
    var overflow = 0.0;

    if (position.dx < 0) overflow += -position.dx;
    if (position.dy < 0) overflow += -position.dy;
    if (position.dx + childSize.width > availableSize.width) {
      overflow += position.dx + childSize.width - availableSize.width;
    }
    if (position.dy + childSize.height > availableSize.height) {
      overflow += position.dy + childSize.height - availableSize.height;
    }

    return overflow;
  }

  @override
  bool shouldRelayout(covariant _UiFlyoutDelegate oldDelegate) {
    return anchor != oldDelegate.anchor ||
        targetRect != oldDelegate.targetRect ||
        direction != oldDelegate.direction;
  }
}
