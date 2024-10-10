import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizzle_starter/src/core/widget/popup/enhanced_composited_transform_follower.dart';
import 'package:sizzle_starter/src/core/widget/popup/enhanced_composited_transform_target.dart';

/// A function that builds a widget with a controller.
typedef PopupWidgetBuilder = Widget Function(
  BuildContext context,
  OverlayPortalController controller,
);

/// {@template popup}
/// A widget that shows a follower widget relative to a target widget.
///
/// Under the hood, it uses [OverlayPortal] that is a declarative version
/// of [OverlayEntry]. In order to position the follower widget relative to
/// the target widget, it uses [CompositedTransformTarget] and
/// [EnhancedCompositedTransformFollower].
///
/// This widget is useful when you want to show a popup, tooltip, or dropdown
/// relative to a target widget. It also automatically manages the position on
/// the screen and ensures that the follower widget is always visible
/// (i.e. it doesn't overflow the screen) by adjusting the position.
/// {@endtemplate}
class PopupBuilder extends StatefulWidget {
  /// Creates a new instance of [PopupBuilder].
  ///
  /// {@macro popup}
  const PopupBuilder({
    required this.followerBuilder,
    required this.targetBuilder,
    this.controller,
    this.followerAnchor = Alignment.topCenter,
    this.targetAnchor = Alignment.bottomCenter,
    this.flipWhenOverflow = true,
    this.moveWhenOverflow = true,
    this.enforceLeaderWidth = false,
    this.enforceLeaderHeight = false,
    super.key,
  });

  /// The target widget that the follower widget [followerBuilder] is positioned relative to.
  final PopupWidgetBuilder targetBuilder;

  /// The widget that is positioned relative to the target widget [targetBuilder].
  final PopupWidgetBuilder followerBuilder;

  /// The alignment of the follower widget relative to the target widget.
  ///
  /// Defaults to [Alignment.topCenter].
  final Alignment followerAnchor;

  /// The alignment of the target widget relative to the follower widget.
  ///
  /// Defaults to [Alignment.bottomCenter].
  final Alignment targetAnchor;

  /// The controller that is used to show/hide the overlay.
  ///
  /// If not provided, a new controller is created.
  final OverlayPortalController? controller;

  /// Whether to flip the follower widget when it overflows the screen.
  ///
  /// For example, if the follower widget overflows the screen on the right side,
  /// it will be flipped to the left side.
  ///
  /// Defaults to `true`.
  final bool flipWhenOverflow;

  /// Whether to adjust the position of the follower widget when it overflows the screen.
  ///
  /// For example, if the follower widget overflows the screen on the right side for 20 pixels,
  /// it will be moved to the left side for 20 pixels, same for the top, bottom, and left sides.
  ///
  /// Defaults to `true`.
  final bool moveWhenOverflow;

  /// Whether to enforce the width of the leader widget on the follower widget.
  ///
  /// This can be useful to make follower widget be the same width as the leader widget.
  ///
  /// Defaults to `false`.
  final bool enforceLeaderWidth;

  /// Whether to enforce the height of the leader widget on the follower widget.
  ///
  /// This can be useful to make follower widget be the same height as the leader widget.
  ///
  /// Defaults to `false`.
  final bool enforceLeaderHeight;

  /// Returns the areas of the screen that are obstructed by display features.
  ///
  /// A [DisplayFeature] obstructs the screen when the area it occupies is
  /// not 0 or the `state` is [DisplayFeatureState.postureHalfOpened].
  static Iterable<Rect> findDisplayFeatureBounds(List<DisplayFeature> features) => features
      .where(
        (DisplayFeature d) =>
            d.bounds.shortestSide > 0 || d.state == DisplayFeatureState.postureHalfOpened,
      )
      .map((DisplayFeature d) => d.bounds);

  @override
  State<PopupBuilder> createState() => _PopupBuilderState();
}

class _PopupBuilderState extends State<PopupBuilder> {
  /// The link between the target widget and the follower widget.
  final _layerLink = EnhancedLayerLink();

  /// The controller that is used to show/hide the overlay.
  late OverlayPortalController portalController;

  @override
  void initState() {
    super.initState();
    portalController = widget.controller ?? OverlayPortalController(debugLabel: 'Popup');
  }

  @override
  void didUpdateWidget(covariant PopupBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!identical(widget.controller, oldWidget.controller)) {
      portalController = widget.controller ?? OverlayPortalController(debugLabel: 'Popup');
    }
  }

  @override
  Widget build(BuildContext context) {
    final displayFeatureBounds = PopupBuilder.findDisplayFeatureBounds(
      MediaQuery.displayFeaturesOf(context),
    );

    return EnhancedCompositedTransformTarget(
      link: _layerLink, // link the target widget to the follower widget.
      child: OverlayPortal(
        controller: portalController,
        child: widget.targetBuilder(context, portalController),
        overlayChildBuilder: (BuildContext context) => Center(
          child: EnhancedCompositedTransformFollower(
            link: _layerLink, // link the follower widget to the target widget.
            followerAnchor: widget.followerAnchor,
            targetAnchor: widget.targetAnchor,
            enforceLeaderWidth: widget.enforceLeaderWidth,
            enforceLeaderHeight: widget.enforceLeaderHeight,
            moveWhenOverflow: widget.moveWhenOverflow,
            flipWhenOverflow: widget.flipWhenOverflow,
            displayFeatureBounds: displayFeatureBounds,
            child: widget.followerBuilder(context, portalController),
          ),
        ),
      ),
    );
  }
}

/// Follower builder that wraps the child widget.
typedef PopupFollowerBuilder = Widget Function(BuildContext context, Widget? child);

/// Handles for follower widgets.
abstract interface class PopupFollowerController {
  /// Dismisses the popup.
  void dismiss();
}

/// {@template popup_follower}
/// A widget that adds additional functionality to the child widget.
///
/// It listens for the escape key and dismisses the popup when pressed.
/// It also listens for the tap outside the child widget and dismisses the popup.
/// {@endtemplate}
class PopupFollower extends StatefulWidget {
  /// Creates a new instance of [PopupFollower].
  ///
  /// {@macro popup_follower}
  const PopupFollower({
    required this.child,
    this.onDismiss,
    this.tapRegionGroupId,
    this.focusScopeNode,
    this.skipTraversal,
    this.consumeOutsideTaps = false,
    this.dismissOnResize = false,
    this.dismissOnScroll = true,
    this.constraints = const BoxConstraints(),
    this.autofocus = true,
    super.key,
  });

  /// The child widget that is wrapped.
  final Widget child;

  /// The callback that is called when the popup is dismissed.
  ///
  /// If this callback is not provided, the popup will not be dismissible.
  final VoidCallback? onDismiss;

  /// Follower constraints, if any.
  final BoxConstraints constraints;

  /// The group id of the [TapRegion].
  ///
  /// Refers to the [TapRegion.groupId].
  final Object? tapRegionGroupId;

  /// Whether to consume the outside taps.
  ///
  /// Refers to the [TapRegion.consumeOutsideTaps].
  final bool consumeOutsideTaps;

  /// Whether to dismiss the popup when the window is resized.
  final bool dismissOnResize;

  /// Whether to dismiss the popup when the scroll occurs.
  final bool dismissOnScroll;

  /// Whether the focus should be set to the child widget.
  final bool autofocus;

  /// The focus scope node.
  final FocusScopeNode? focusScopeNode;

  /// Whether to skip the focus traversal.
  final bool? skipTraversal;

  @override
  State<PopupFollower> createState() => _PopupFollowerState();
}

class _PopupFollowerState extends State<PopupFollower>
    with WidgetsBindingObserver
    implements PopupFollowerController {
  _FollowerScope? _parent;
  ScrollPosition? _scrollPosition;

  /// Whether the current widget is the root widget.
  bool get isRoot => _parent == null;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeDependencies() {
    _scrollPosition?.removeListener(_scrollableListener);
    _scrollPosition = Scrollable.maybeOf(context)?.position?..addListener(_scrollableListener);
    _parent = _FollowerScope.maybeOf(context, listen: true);
    super.didChangeDependencies();
  }

  @override
  void didChangeMetrics() {
    if (widget.dismissOnResize) {
      widget.onDismiss?.call();
    }
    super.didChangeMetrics();
  }

  void _scrollableListener() {
    if (widget.onDismiss != null && widget.dismissOnScroll && isRoot) {
      widget.onDismiss?.call();
    }
  }

  @override
  void dismiss() {
    if (widget.onDismiss != null && isRoot) {
      widget.onDismiss?.call();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _scrollPosition?.removeListener(_scrollableListener);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) => _FollowerScope(
        controller: this,
        parent: _parent,
        child: Actions(
          actions: {
            DismissIntent: CallbackAction<DismissIntent>(
              onInvoke: (intent) => widget.onDismiss?.call(),
            ),
          },
          child: Shortcuts(
            debugLabel: 'PopupFollower',
            shortcuts: {
              LogicalKeySet(LogicalKeyboardKey.escape): const DismissIntent(),
            },
            child: Semantics(
              container: true,
              explicitChildNodes: true,
              child: FocusScope(
                debugLabel: 'PopupFollower',
                node: widget.focusScopeNode,
                skipTraversal: widget.skipTraversal,
                canRequestFocus: true,
                child: TapRegion(
                  debugLabel: 'PopupFollower',
                  groupId: widget.tapRegionGroupId,
                  consumeOutsideTaps: widget.consumeOutsideTaps,
                  onTapOutside: (_) => widget.onDismiss?.call(),
                  child: ConstrainedBox(
                    constraints: widget.constraints,
                    child: widget.child,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
}

/// Follower Scope
class _FollowerScope extends InheritedWidget {
  /// Creates a new instance of [_FollowerScope].
  const _FollowerScope({
    required super.child,
    required this.controller,
    this.parent,
    super.key, // ignore: unused_element
  });

  /// The controller that is used to dismiss the popup.
  final PopupFollowerController controller;

  /// The parent [_FollowerScope] instance.
  final _FollowerScope? parent;

  /// Returns the closest [_FollowerScope] instance.
  static _FollowerScope? maybeOf(BuildContext context, {bool listen = false}) => listen
      ? context.dependOnInheritedWidgetOfExactType<_FollowerScope>()
      : context.getElementForInheritedWidgetOfExactType<_FollowerScope>()?.widget
          as _FollowerScope?;

  @override
  bool updateShouldNotify(_FollowerScope oldWidget) => false;
}
