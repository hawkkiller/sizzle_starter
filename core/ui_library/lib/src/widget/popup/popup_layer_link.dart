import 'package:flutter/material.dart';
import 'package:ui_library/src/widget/popup/composited_transform_popup_follower.dart';
import 'package:ui_library/src/widget/popup/composited_transform_popup_target.dart';

/// A link that can be established between a [CompositedTransformPopupTarget] and a
/// [CompositedTransformPopupFollower].
///
/// The only difference between this and the original [LayerLink] is that this
/// class has a [leaderRenderObject] property that is used to store the render
/// object of the leader.
class PopupLayerLink extends LayerLink {
  /// The render object of the leader.
  RenderPopupLeaderLayer? leaderRenderObject;

  Size? _leaderSize;

  @override
  Size? get leaderSize => _leaderSize;

  @override
  set leaderSize(Size? leaderSize) {
    _leaderSize = leaderSize;
    super.leaderSize = leaderSize;
  }
}
