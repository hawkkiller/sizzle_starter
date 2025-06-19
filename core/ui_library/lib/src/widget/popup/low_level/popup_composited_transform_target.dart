import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:ui_library/src/widget/popup/low_level/popup_layer_link.dart';

/// [CompositedTransformTarget] that also stores the render object of the leader.
class PopupCompositedTransformTarget extends SingleChildRenderObjectWidget {
  const PopupCompositedTransformTarget({required this.link, super.key, super.child});

  final PopupLayerLink link;

  @override
  PopupRenderLeaderLayer createRenderObject(BuildContext context) =>
      PopupRenderLeaderLayer(link: link);

  @override
  void updateRenderObject(BuildContext context, PopupRenderLeaderLayer renderObject) {
    renderObject.link = link;
  }
}

/// [RenderLeaderLayer] that also stores the render object of the leader.
class PopupRenderLeaderLayer extends RenderLeaderLayer {
  PopupRenderLeaderLayer({required PopupLayerLink link, super.child}) : super(link: link);

  @override
  PopupLayerLink get link => super.link as PopupLayerLink;

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    link.leaderRenderObject = this;
  }

  @override
  void detach() {
    super.detach();
    link.leaderRenderObject = null;
  }
}
