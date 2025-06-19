import 'package:flutter/material.dart';
import 'package:ui_library/src/widget/popup/low_level/popup_composited_transform_follower.dart';
import 'package:ui_library/src/widget/popup/low_level/popup_composited_transform_target.dart';

/// A link that can be established between a [PopupCompositedTransformTarget] and a
/// [PopupCompositedTransformFollower].
///
/// The only difference between this and the original [LayerLink] is that this
/// class has a [leaderRenderObject] property that is used to store the render
/// object of the leader.
class PopupLayerLink extends LayerLink {
  /// The render object of the leader.
  PopupRenderLeaderLayer? leaderRenderObject;

  Size? _leaderSize;

  @override
  Size? get leaderSize => _leaderSize;

  @override
  set leaderSize(Size? leaderSize) {
    _leaderSize = leaderSize;
    super.leaderSize = leaderSize;
  }
}
