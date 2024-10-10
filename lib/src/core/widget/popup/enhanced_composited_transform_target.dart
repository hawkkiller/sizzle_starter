import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:sizzle_starter/src/core/widget/popup/enhanced_composited_transform_follower.dart';

/// A link that can be established between a [EnhancedCompositedTransformTarget] and a
/// [EnhancedCompositedTransformFollower].
///
/// The only difference between this and the original [LayerLink] is that this
/// class has a [leaderRenderObject] property that is used to store the render
/// object of the leader.
class EnhancedLayerLink extends LayerLink {
  /// The render object of the leader.
  EnhancedRenderLeaderLayer? leaderRenderObject;

  /// The render object of the follower.
  EnhancedRenderFollowerLayer? followerRenderObject;

  /// Callback that is called when the size of the leader changes.
  void leaderUpdated(Size? size) {
    leaderSize = size;
    followerRenderObject?.leaderUpdated();
  }
}

/// A widget that can be targeted by a [CompositedTransformFollower].
///
/// When this widget is composited during the compositing phase (which comes
/// after the paint phase, as described in [WidgetsBinding.drawFrame]), it
/// updates the [link] object so that any [CompositedTransformFollower] widgets
/// that are subsequently composited in the same frame and were given the same
/// [LayerLink] can position themselves at the same screen location.
///
/// A single [EnhancedCompositedTransformTarget] can be followed by multiple
/// [CompositedTransformFollower] widgets.
///
/// The [EnhancedCompositedTransformTarget] must come earlier in the paint order than
/// any linked [CompositedTransformFollower]s.
///
/// See also:
///
///  * [CompositedTransformFollower], the widget that can target this one.
///  * [LeaderLayer], the layer that implements this widget's logic.
class EnhancedCompositedTransformTarget extends SingleChildRenderObjectWidget {
  /// Creates a composited transform target widget.
  ///
  /// The [link] property must not be currently used by any other
  /// [EnhancedCompositedTransformTarget] object that is in the tree.
  const EnhancedCompositedTransformTarget({
    required this.link,
    super.key,
    super.child,
  });

  /// The link object that connects this [EnhancedCompositedTransformTarget] with one or
  /// more [CompositedTransformFollower]s.
  ///
  /// The link must not be associated with another [EnhancedCompositedTransformTarget]
  /// that is also being painted.
  final EnhancedLayerLink link;

  @override
  EnhancedRenderLeaderLayer createRenderObject(BuildContext context) =>
      EnhancedRenderLeaderLayer(link: link);

  @override
  void updateRenderObject(BuildContext context, EnhancedRenderLeaderLayer renderObject) {
    renderObject.link = link;
  }
}

/// Provides an anchor for a [RenderFollowerLayer].
///
/// See also:
///
///  * [EnhancedCompositedTransformTarget], the corresponding widget.
///  * [LeaderLayer], the layer that this render object creates.
class EnhancedRenderLeaderLayer extends RenderProxyBox {
  /// Creates a render object that uses a [LeaderLayer].
  EnhancedRenderLeaderLayer({
    required EnhancedLayerLink link,
    RenderBox? child,
  })  : _link = link,
        super(child);

  /// The link object that connects this [EnhancedRenderLeaderLayer] with one or more
  /// [RenderFollowerLayer]s.
  ///
  /// The object must not be associated with another [EnhancedRenderLeaderLayer] that is
  /// also being painted.
  EnhancedLayerLink get link => _link;
  EnhancedLayerLink _link;
  set link(EnhancedLayerLink value) {
    if (_link == value) {
      return;
    }
    _link.leaderUpdated(null);
    _link = value;
    _link.leaderRenderObject = this;
    if (_previousLayoutSize != null) {
      _link.leaderUpdated(_previousLayoutSize);
    }
    markNeedsPaint();
  }

  @override
  bool get alwaysNeedsCompositing => true;

  // The latest size of this [RenderBox], computed during the previous layout
  // pass. It should always be equal to [size], but can be accessed even when
  // [debugDoingThisResize] and [debugDoingThisLayout] are false.
  Size? _previousLayoutSize;

  @override
  void performLayout() {
    super.performLayout();
    if (_previousLayoutSize != size) {
      // calculate rect
      link.leaderUpdated(size);
      _previousLayoutSize = size;
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (layer == null) {
      layer = LeaderLayer(link: link, offset: offset);
    } else {
      final leaderLayer = layer! as LeaderLayer;
      leaderLayer
        ..link = link
        ..offset = offset;
    }
    context.pushLayer(layer!, super.paint, Offset.zero);
    assert(
      () {
        layer!.debugCreator = debugCreator;
        return true;
      }(),
      '',
    );
  }

  @override
  void attach(PipelineOwner owner) {
    link.leaderRenderObject = this;
    super.attach(owner);
  }

  @override
  void detach() {
    layer = null;
    link.leaderRenderObject = null;
    _previousLayoutSize = null;
    super.detach();
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<LayerLink>('link', link));
  }
}
