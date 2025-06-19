import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:ui_library/src/widget/popup/low_level/popup_composited_transform_target.dart';
import 'package:ui_library/src/widget/popup/low_level/popup_layer_link.dart';

/// A widget that follows a [PopupCompositedTransformTarget].
///
/// The only difference between this widget and [CompositedTransformFollower] is
/// that this widget prevents the follower from overflowing the screen.
class PopupCompositedTransformFollower extends SingleChildRenderObjectWidget {
  const PopupCompositedTransformFollower({
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

  final PopupLayerLink link;
  final bool showWhenUnlinked;
  final Alignment targetAnchor;
  final Alignment followerAnchor;
  final bool flipWhenOverflow;
  final bool moveWhenOverflow;
  final bool enforceLeaderWidth;
  final bool enforceLeaderHeight;
  final Iterable<Rect> displayFeatureBounds;

  @override
  EnhancedRenderFollowerLayer createRenderObject(BuildContext context) {
    return EnhancedRenderFollowerLayer(
      link: link,
      showWhenUnlinked: showWhenUnlinked,
      targetAnchor: targetAnchor,
      followerAnchor: followerAnchor,
      enforceLeaderWidth: enforceLeaderWidth,
      enforceLeaderHeight: enforceLeaderHeight,
      flipWhenOverflow: flipWhenOverflow,
      moveWhenOverflow: moveWhenOverflow,
      displayFeatureBounds: displayFeatureBounds,
    );
  }

  @override
  void updateRenderObject(BuildContext context, EnhancedRenderFollowerLayer renderObject) {
    renderObject
      ..link = link
      ..showWhenUnlinked = showWhenUnlinked
      ..targetAnchor = targetAnchor
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
    required PopupLayerLink link,
    required Iterable<Rect> displayFeatureBounds,
    Alignment targetAnchor = Alignment.topLeft,
    Alignment followerAnchor = Alignment.topLeft,
    bool showWhenUnlinked = true,
    bool flipWhenOverflow = true,
    bool moveWhenOverflow = true,
    bool enforceLeaderWidth = false,
    bool enforceLeaderHeight = false,
    RenderBox? child,
  }) : _link = link,
       _flipWhenOverflow = flipWhenOverflow,
       _moveWhenOverflow = moveWhenOverflow,
       _showWhenUnlinked = showWhenUnlinked,
       _targetAnchor = targetAnchor,
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
  PopupLayerLink get link => _link;
  PopupLayerLink _link;
  set link(PopupLayerLink value) {
    if (_link == value) {
      return;
    }
    _link = value;
    markNeedsPaint();
  }

  bool get showWhenUnlinked => _showWhenUnlinked;
  bool _showWhenUnlinked;
  set showWhenUnlinked(bool value) {
    if (_showWhenUnlinked == value) {
      return;
    }
    _showWhenUnlinked = value;
    markNeedsPaint();
  }

  /// {@template popup.rendering.leader_anchor}
  /// The anchor point on the linked [RenderLeaderLayer] that [targetAnchor]
  /// will line up with.
  ///
  /// {@endtemplate}
  Alignment get targetAnchor => _targetAnchor;
  Alignment _targetAnchor;
  set targetAnchor(Alignment value) {
    if (_targetAnchor == value) {
      return;
    }
    _targetAnchor = value;
    markNeedsPaint();
  }

  /// {@template popup.rendering.follower_anchor}
  /// The anchor point on the linked [RenderLeaderLayer] that [followerAnchor]
  /// will line up with.
  ///
  /// {@endtemplate}
  Alignment get followerAnchor => _followerAnchor;
  Alignment _followerAnchor;
  set followerAnchor(Alignment value) {
    if (_followerAnchor == value) {
      return;
    }
    _followerAnchor = value;
    markNeedsPaint();
  }

  /// {@template popup.rendering.flip_when_overflow}
  /// Whether to flip the follower widget when it overflows the screen.
  ///
  /// Defaults to `true`.
  /// {@endtemplate}
  bool get flipWhenOverflow => _flipWhenOverflow;
  bool _flipWhenOverflow;
  set flipWhenOverflow(bool value) {
    if (_flipWhenOverflow == value) {
      return;
    }
    _flipWhenOverflow = value;
    markNeedsPaint();
  }

  /// {@template popup.rendering.move_when_overflow}
  /// Whether to move the follower widget when it overflows the screen.
  ///
  /// Defaults to `true`.
  /// {@endtemplate}
  bool get moveWhenOverflow => _moveWhenOverflow;
  bool _moveWhenOverflow;
  set moveWhenOverflow(bool value) {
    if (_moveWhenOverflow == value) {
      return;
    }
    _moveWhenOverflow = value;
    markNeedsPaint();
  }

  /// {@template popup.rendering.enforce_leader_width}
  /// Whether to enforce the width of the leader widget on the follower widget.
  ///
  /// Defaults to `false`.
  /// {@endtemplate}
  bool get enforceLeaderWidth => _enforceLeaderWidth;
  bool _enforceLeaderWidth;
  set enforceLeaderWidth(bool value) {
    if (_enforceLeaderWidth == value) {
      return;
    }
    _enforceLeaderWidth = value;
    markNeedsPaint();
  }

  /// {@template popup.rendering.enforce_leader_height}
  /// Whether to enforce the height of the leader widget on the follower widget.
  ///
  /// Defaults to `false`.
  /// {@endtemplate}
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
    final leaderSize = link.leaderSize;

    assert(
      leaderSize != null,
      'leaderSize should not be null. If it is null, the follower widget will not be able to be positioned correctly.',
    );

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

      // TODO(mlazebny): figure out how to correctly treat allowedRect
      // final overlayRect = Offset.zero & constraints.biggest;
      // final subScreens = DisplayFeatureSubScreen.subScreensInBounds(
      //   overlayRect,
      //   displayFeatureBounds,
      // );
      // final allowedRect = _closestScreen(subScreens, leaderGlobalPosition);

      // Where the follower would like to be positioned relative to the leader
      linkedOffset = targetAnchor.alongSize(leaderSize) - followerAnchor.alongSize(size);
      final followerGlobalPosition = leaderGlobalPosition + linkedOffset;

      linkedOffset =
          calculateLinkedOffset(
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

    assert(() {
      layer!.debugCreator = debugCreator;
      return true;
    }(), '');
  }

  /// Calculate the offset of the follower widget.
  static Offset calculateLinkedOffset({
    required Rect followerRect,
    required Rect targetRect,
    required Size screenSize,
    required bool flipWhenOverflow,
    required bool moveWhenOverflow,
  }) {
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
      minBoundary: 0,
      maxBoundary: screenSize.width,
      altPosition: targetRect.left,
      altSize: targetRect.width,
    );

    // Adjust vertical position
    final dy = adjust(
      position: followerRect.top,
      size: followerRect.height,
      minBoundary: 0,
      maxBoundary: screenSize.height,
      altPosition: targetRect.top,
      altSize: targetRect.height,
    );

    return Offset(dx, dy);
  }

  // Rect _closestScreen(Iterable<Rect> screens, Offset point) {
  //   var closest = screens.first;
  //   for (final screen in screens) {
  //     if ((screen.center - point).distance < (closest.center - point).distance) {
  //       closest = screen;
  //     }
  //   }
  //   return closest;
  // }

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
