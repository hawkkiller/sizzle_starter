import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:sizzle_starter/src/core/widget/popup/enhanced_composited_transform_target.dart';

/// A widget that follows a [CompositedTransformTarget].
///
/// The only difference between this widget and [CompositedTransformFollower] is
/// that this widget prevents the follower from overflowing the screen.
///
/// When this widget is composited during the compositing phase (which comes
/// after the paint phase, as described in [WidgetsBinding.drawFrame]), it
/// applies a transformation that brings [targetAnchor] of the linked
/// [CompositedTransformTarget] and [followerAnchor] of this widget together.
/// The [LayerLink] object used as the [link] must be the same object as that
/// provided to the matching [CompositedTransformTarget].
///
/// The [CompositedTransformTarget] must come earlier in the paint order than
/// this [EnhancedCompositedTransformFollower].
///
/// Hit testing on descendants of this widget will only work if the target
/// position is within the box that this widget's parent considers to be
/// hittable. If the parent covers the screen, this is trivially achievable, so
/// this widget is usually used as the root of an [OverlayEntry] in an app-wide
/// [Overlay] (e.g. as created by the [MaterialApp] widget's [Navigator]).
///
/// See also:
///
///  * [CompositedTransformTarget], the widget that this widget can target.
///  * [FollowerLayer], the layer that implements this widget's logic.
///  * [Transform], which applies an arbitrary transform to a child.
class EnhancedCompositedTransformFollower extends SingleChildRenderObjectWidget {
  /// Creates a composited transform target widget.
  ///
  /// If the [link] property was also provided to a [CompositedTransformTarget],
  /// that widget must come earlier in the paint order.
  ///
  /// The [showWhenUnlinked] argument must not be null.
  const EnhancedCompositedTransformFollower({
    required this.link,
    required this.displayFeatureBounds,
    this.targetAnchor = Alignment.topLeft,
    this.followerAnchor = Alignment.topLeft,
    this.showWhenUnlinked = false,
    this.enforceLeaderWidth = false,
    this.enforceLeaderHeight = false,
    this.flipWhenOverflow = true,
    this.moveWhenOverflow = true,
    super.child,
    super.key,
  });

  /// The link object that connects this [EnhancedCompositedTransformFollower] with a
  /// [CompositedTransformTarget].
  final EnhancedLayerLink link;

  /// Whether to show the widget's contents when there is no corresponding
  /// [CompositedTransformTarget] with the same [link].
  ///
  /// When the widget is linked, the child is positioned such that it has the
  /// same global position as the linked [CompositedTransformTarget].
  ///
  /// When the widget is not linked, then: if [showWhenUnlinked] is true, the
  /// child is visible and not repositioned; if it is false, then child is
  /// hidden.
  final bool showWhenUnlinked;

  /// The anchor point on the linked [CompositedTransformTarget] that
  /// [followerAnchor] will line up with.
  ///
  /// {@template flutter.widgets.CompositedTransformFollower.targetAnchor}
  /// For example, when [targetAnchor] and [followerAnchor] are both
  /// [Alignment.topLeft], this widget will be top left aligned with the linked
  /// [CompositedTransformTarget]. When [targetAnchor] is
  /// [Alignment.bottomLeft] and [followerAnchor] is [Alignment.topLeft], this
  /// widget will be left aligned with the linked [CompositedTransformTarget],
  /// and its top edge will line up with the [CompositedTransformTarget]'s
  /// bottom edge.
  /// {@endtemplate}
  ///
  /// Defaults to [Alignment.topLeft].
  final Alignment targetAnchor;

  /// The anchor point on this widget that will line up with [targetAnchor] on
  /// the linked [CompositedTransformTarget].
  ///
  /// {@macro flutter.widgets.CompositedTransformFollower.targetAnchor}
  ///
  /// Defaults to [Alignment.topLeft].
  final Alignment followerAnchor;

  /// Whether to flip the follower widget when it overflows the screen.
  ///
  /// For example, if the follower widget overflows the screen on one side and
  /// on the other side there is enough space, the follower widget will be
  /// flipped to the other side.
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

  /// List of rects that may be obstructed by physical features.
  final Iterable<Rect> displayFeatureBounds;

  @override
  EnhancedRenderFollowerLayer createRenderObject(BuildContext context) =>
      EnhancedRenderFollowerLayer(
        link: link,
        showWhenUnlinked: showWhenUnlinked,
        leaderAnchor: targetAnchor,
        followerAnchor: followerAnchor,
        enforceLeaderWidth: enforceLeaderWidth,
        enforceLeaderHeight: enforceLeaderHeight,
        flipWhenOverflow: flipWhenOverflow,
        moveWhenOverflow: moveWhenOverflow,
        displayFeatureBounds: displayFeatureBounds,
      );

  @override
  void updateRenderObject(BuildContext context, EnhancedRenderFollowerLayer renderObject) {
    renderObject
      ..link = link
      ..showWhenUnlinked = showWhenUnlinked
      ..leaderAnchor = targetAnchor
      ..followerAnchor = followerAnchor
      ..moveWhenOverflow = moveWhenOverflow
      ..flipWhenOverflow = flipWhenOverflow
      ..enforceLeaderWidth = enforceLeaderWidth
      ..enforceLeaderHeight = enforceLeaderHeight
      ..displayFeatureBounds = displayFeatureBounds;
  }
}

/// Transform the child so that its origin is offset from the origin of the
/// [RenderLeaderLayer] with the same [LayerLink].
///
/// The [RenderLeaderLayer] in question must be earlier in the paint order.
///
/// Hit testing on descendants of this render object will only work if the
/// target position is within the box that this render object's parent considers
/// to be hittable.
///
/// See also:
///
///  * [CompositedTransformFollower], the corresponding widget.
///  * [FollowerLayer], the layer that this render object creates.
class EnhancedRenderFollowerLayer extends RenderProxyBox {
  /// Creates a render object that uses a [FollowerLayer].
  EnhancedRenderFollowerLayer({
    required EnhancedLayerLink link,
    required Iterable<Rect> displayFeatureBounds,
    Alignment leaderAnchor = Alignment.topLeft,
    Alignment followerAnchor = Alignment.topLeft,
    bool showWhenUnlinked = true,
    bool flipWhenOverflow = true,
    bool moveWhenOverflow = true,
    bool enforceLeaderWidth = false,
    bool enforceLeaderHeight = false,
    RenderBox? child,
  })  : _link = link,
        _flipWhenOverflow = flipWhenOverflow,
        _moveWhenOverflow = moveWhenOverflow,
        _showWhenUnlinked = showWhenUnlinked,
        _leaderAnchor = leaderAnchor,
        _followerAnchor = followerAnchor,
        _enforceLeaderWidth = enforceLeaderWidth,
        _enforceLeaderHeight = enforceLeaderHeight,
        _displayFeatureBounds = displayFeatureBounds,
        super(child);

  /// Called when the size of the leader widget changes.
  void leaderUpdated() {
    if (_enforceLeaderHeight || _enforceLeaderWidth) {
      RendererBinding.instance.addPostFrameCallback((_) {
        markNeedsLayout();
      });
    }
  }

  /// List of rects that may be obstructed by physical features.
  Iterable<Rect> get displayFeatureBounds => _displayFeatureBounds;
  Iterable<Rect> _displayFeatureBounds;
  set displayFeatureBounds(Iterable<Rect> value) {
    if (_displayFeatureBounds == value) {
      return;
    }
    _displayFeatureBounds = value;
    markNeedsPaint();
  }

  /// The link object that connects this [EnhancedRenderFollowerLayer] with a
  /// [RenderLeaderLayer] earlier in the paint order.
  EnhancedLayerLink get link => _link;
  EnhancedLayerLink _link;
  set link(EnhancedLayerLink value) {
    if (_link == value) {
      return;
    }
    _link = value;
    markNeedsPaint();
  }

  /// Whether to show the render object's contents when there is no
  /// corresponding [RenderLeaderLayer] with the same [link].
  ///
  /// When the render object is linked, the child is positioned such that it has
  /// the same global position as the linked [RenderLeaderLayer].
  ///
  /// When the render object is not linked, then: if [showWhenUnlinked] is true,
  /// the child is visible and not repositioned; if it is false, then child is
  /// hidden, and its hit testing is also disabled.
  bool get showWhenUnlinked => _showWhenUnlinked;
  bool _showWhenUnlinked;
  set showWhenUnlinked(bool value) {
    if (_showWhenUnlinked == value) {
      return;
    }
    _showWhenUnlinked = value;
    markNeedsPaint();
  }

  /// Whether to adjust the position of the follower widget when it overflows the screen.
  ///
  /// For example, if the follower widget overflows the screen on the right side for 20 pixels,
  /// it will be moved to the left side for 20 pixels, same for the top, bottom, and left sides.
  ///
  /// Defaults to `true`.
  bool get moveWhenOverflow => _moveWhenOverflow;
  bool _moveWhenOverflow;

  set moveWhenOverflow(bool value) {
    if (_moveWhenOverflow == value) {
      return;
    }
    _moveWhenOverflow = value;
    markNeedsPaint();
  }

  /// The anchor point on the linked [RenderLeaderLayer] that [followerAnchor]
  /// will line up with.
  ///
  /// {@template flutter.rendering.RenderFollowerLayer.leaderAnchor}
  /// For example, when [leaderAnchor] and [followerAnchor] are both
  /// [Alignment.topLeft], this [EnhancedRenderFollowerLayer] will be top left aligned
  /// with the linked [RenderLeaderLayer]. When [leaderAnchor] is
  /// [Alignment.bottomLeft] and [followerAnchor] is [Alignment.topLeft], this
  /// [EnhancedRenderFollowerLayer] will be left aligned with the linked
  /// [RenderLeaderLayer], and its top edge will line up with the
  /// [RenderLeaderLayer]'s bottom edge.
  /// {@endtemplate}
  ///
  /// Defaults to [Alignment.topLeft].
  Alignment get leaderAnchor => _leaderAnchor;
  Alignment _leaderAnchor;
  set leaderAnchor(Alignment value) {
    if (_leaderAnchor == value) {
      return;
    }
    _leaderAnchor = value;
    markNeedsPaint();
  }

  /// The anchor point on this [EnhancedRenderFollowerLayer] that will line up with
  /// [followerAnchor] on the linked [RenderLeaderLayer].
  ///
  /// {@macro flutter.rendering.RenderFollowerLayer.leaderAnchor}
  ///
  /// Defaults to [Alignment.topLeft].
  Alignment get followerAnchor => _followerAnchor;
  Alignment _followerAnchor;
  set followerAnchor(Alignment value) {
    if (_followerAnchor == value) {
      return;
    }
    _followerAnchor = value;
    markNeedsPaint();
  }

  /// Whether to flip the follower widget when it overflows the screen.
  ///
  /// For example, if the follower widget overflows the screen on the right side,
  /// it will be flipped to the left side.
  ///
  /// Defaults to `true`.
  bool get flipWhenOverflow => _flipWhenOverflow;

  bool _flipWhenOverflow;
  set flipWhenOverflow(bool value) {
    if (_flipWhenOverflow == value) {
      return;
    }
    _flipWhenOverflow = value;
    markNeedsPaint();
  }

  /// Whether to enforce the width of the leader widget on the follower widget.
  ///
  /// This can be useful to make follower widget be the same width as the leader widget.
  ///
  /// Defaults to `false`.
  bool get enforceLeaderWidth => _enforceLeaderWidth;
  bool _enforceLeaderWidth;
  set enforceLeaderWidth(bool value) {
    if (_enforceLeaderWidth == value) {
      return;
    }
    _enforceLeaderWidth = value;
    markNeedsPaint();
  }

  /// Whether to enforce the height of the leader widget on the follower widget.
  ///
  /// This can be useful to make follower widget be the same height as the leader widget.
  ///
  /// Defaults to `false`.
  bool get enforceLeaderHeight => _enforceLeaderHeight;
  bool _enforceLeaderHeight;
  set enforceLeaderHeight(bool value) {
    if (_enforceLeaderHeight == value) {
      return;
    }
    _enforceLeaderHeight = value;
    markNeedsPaint();
  }

  @override
  void attach(PipelineOwner owner) {
    link.followerRenderObject = this;
    super.attach(owner);
  }

  @override
  void detach() {
    layer = null;
    link.followerRenderObject = null;
    super.detach();
  }

  @override
  bool get alwaysNeedsCompositing => true;

  /// The layer we created when we were last painted.
  @override
  FollowerLayer? get layer => super.layer as FollowerLayer?;

  /// Return the transform that was used in the last composition phase, if any.
  ///
  /// If the [FollowerLayer] has not yet been created, was never composited, or
  /// was unable to determine the transform (see
  /// [FollowerLayer.getLastTransform]), this returns the identity matrix (see
  /// [Matrix4.identity].
  Matrix4 getCurrentTransform() => layer?.getLastTransform() ?? Matrix4.identity();

  @override
  void performLayout() {
    var constraints = this.constraints;
    // use leader size if enforceLeaderWidth or enforceLeaderHeight is true
    final leaderSize = link.leaderSize;

    if (leaderSize != null) {
      if (enforceLeaderWidth) {
        constraints = constraints.copyWith(
          minWidth: leaderSize.width,
          maxWidth: leaderSize.width,
        );
      }

      if (enforceLeaderHeight) {
        constraints = constraints.copyWith(
          minHeight: leaderSize.height,
          maxHeight: leaderSize.height,
        );
      }
    }

    size = (child!..layout(constraints, parentUsesSize: true)).size;
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final leaderRenderObject = link.leaderRenderObject;
    var linkedOffset = Offset.zero;

    if (leaderRenderObject != null) {
      final leaderGlobalPosition = leaderRenderObject.localToGlobal(Offset.zero);
      final leaderSize = leaderRenderObject.size;
      final overlayRect = Offset.zero & constraints.biggest;

      final subScreens = DisplayFeatureSubScreen.subScreensInBounds(
        overlayRect,
        displayFeatureBounds,
      );

      // TODO(mlazebny): figure out how to correctly treat allowedRect
      // ignore: unused_local_variable
      final allowedRect = _closestScreen(subScreens, leaderGlobalPosition);

      // Where the follower would like to be positioned relative to the leader
      linkedOffset = leaderAnchor.alongSize(leaderSize) - followerAnchor.alongSize(size);
      final followerGlobalPosition = leaderGlobalPosition + linkedOffset;

      linkedOffset = calculateLinkedOffset(
            followerRect: followerGlobalPosition & size,
            targetRect: leaderGlobalPosition & leaderSize,
            screenSize: constraints.biggest,
            flipWhenOverflow: flipWhenOverflow,
            moveWhenOverflow: moveWhenOverflow,
          ) -
          leaderGlobalPosition;
    }

    if (layer == null) {
      layer = FollowerLayer(
        link: link,
        showWhenUnlinked: showWhenUnlinked,
        linkedOffset: linkedOffset,
        unlinkedOffset: offset,
      );
    } else {
      layer
        ?..link = link
        ..showWhenUnlinked = showWhenUnlinked
        ..linkedOffset = linkedOffset
        ..unlinkedOffset = offset;
    }

    context.pushLayer(
      layer!,
      super.paint,
      Offset.zero,
      childPaintBounds: const Rect.fromLTRB(
        double.negativeInfinity,
        double.negativeInfinity,
        double.infinity,
        double.infinity,
      ),
    );

    assert(
      () {
        layer!.debugCreator = debugCreator;
        return true;
      }(),
      '',
    );
  }

  /// Calculate the offset of the follower widget.
  @visibleForTesting
  static Offset calculateLinkedOffset({
    required Rect followerRect,
    required Rect targetRect,
    required Size screenSize,
    required bool flipWhenOverflow,
    required bool moveWhenOverflow,
  }) {
    // Effective screen area considering edge padding
    const leftBoundary = 0.0;
    const topBoundary = 0.0;
    final rightBoundary = screenSize.width;
    final bottomBoundary = screenSize.height;

    // Helper function to adjust for overflow
    double adjust({
      required double position,
      required double size,
      required double minBoundary,
      required double maxBoundary,
      required double altPosition,
      required double altSize,
    }) {
      var adjustedPosition = position;

      if (flipWhenOverflow) {
        // If `flipWhenOverflow` is true, try placing on the opposite side if there's an overflow
        if (position + size > maxBoundary) {
          if (altPosition - size >= minBoundary) {
            adjustedPosition = altPosition - size;
          } else {
            adjustedPosition = maxBoundary - size;
          }
        } else if (position < minBoundary) {
          if (altPosition + altSize <= maxBoundary) {
            adjustedPosition = altPosition + altSize;
          } else {
            adjustedPosition = minBoundary;
          }
        }
      }

      // Handle moving when overflow
      if (moveWhenOverflow) {
        if (adjustedPosition + size > maxBoundary) {
          adjustedPosition = maxBoundary - size;
        } else if (adjustedPosition < minBoundary) {
          adjustedPosition = minBoundary;
        }
      }

      return adjustedPosition;
    }

    // Adjust horizontal position
    final dx = adjust(
      position: followerRect.left,
      size: followerRect.width,
      minBoundary: leftBoundary,
      maxBoundary: rightBoundary,
      altPosition: targetRect.left,
      altSize: targetRect.width,
    );

    // Adjust vertical position
    final dy = adjust(
      position: followerRect.top,
      size: followerRect.height,
      minBoundary: topBoundary,
      maxBoundary: bottomBoundary,
      altPosition: targetRect.top,
      altSize: targetRect.height,
    );

    return Offset(dx, dy);
  }

  Rect _closestScreen(Iterable<Rect> screens, Offset point) {
    var closest = screens.first;
    for (final screen in screens) {
      if ((screen.center - point).distance < (closest.center - point).distance) {
        closest = screen;
      }
    }
    return closest;
  }

  @override
  void applyPaintTransform(RenderBox child, Matrix4 transform) {
    transform.multiply(getCurrentTransform());
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<LayerLink>('link', link));
    properties.add(DiagnosticsProperty<bool>('showWhenUnlinked', showWhenUnlinked));
    properties.add(TransformProperty('current transform matrix', getCurrentTransform()));
  }

  @override
  bool hitTest(BoxHitTestResult result, {required Offset position}) {
    // Disables the hit testing if this render object is hidden.
    if (link.leader == null && !showWhenUnlinked) {
      return false;
    }
    // RenderFollowerLayer objects don't check if they are
    // themselves hit, because it's confusing to think about
    // how the untransformed size and the child's transformed
    // position interact.
    return hitTestChildren(result, position: position);
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) =>
      result.addWithPaintTransform(
        transform: getCurrentTransform(),
        position: position,
        hitTest: (BoxHitTestResult result, Offset position) =>
            super.hitTestChildren(result, position: position),
      );
}
