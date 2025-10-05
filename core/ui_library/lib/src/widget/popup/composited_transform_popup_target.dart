import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:ui_library/src/widget/popup/popup_layer_link.dart';

/// [CompositedTransformTarget] that also stores the render object of the leader.
class CompositedTransformPopupTarget extends SingleChildRenderObjectWidget {
  const CompositedTransformPopupTarget({required this.link, super.key, super.child});

  final PopupLayerLink link;

  @override
  RenderPopupLeaderLayer createRenderObject(BuildContext context) =>
      RenderPopupLeaderLayer(link: link);

  @override
  // ignore: consistent-update-render-object
  void updateRenderObject(BuildContext context, RenderPopupLeaderLayer renderObject) {
    renderObject.link = link;
  }
}

/// [RenderLeaderLayer] that also stores the render object of the leader.
class RenderPopupLeaderLayer extends RenderLeaderLayer {
  RenderPopupLeaderLayer({required PopupLayerLink link, super.child}) : super(link: link);

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
