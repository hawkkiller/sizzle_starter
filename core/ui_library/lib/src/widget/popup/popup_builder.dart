import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:ui_library/src/widget/popup/composited_transform_popup_follower.dart';
import 'package:ui_library/src/widget/popup/composited_transform_popup_target.dart';
import 'package:ui_library/src/widget/popup/popup_layer_link.dart';

/// A widget that shows a follower widget relative to a target widget.
///
/// Under the hood, it uses [OverlayPortal] that is a declarative version
/// of [OverlayEntry]. In order to position the follower widget relative to
/// the target widget, it uses [CompositedTransformTarget] and
/// [CompositedTransformFollower].
///
/// This widget is useful when you want to show a popup, tooltip, or dropdown
/// relative to a target widget. It also automatically manages the position on
/// the screen and ensures that the follower widget is always visible
/// (i.e. it doesn't overflow the screen) by adjusting the position.
///
/// This widget is considered a low-level API. If you want to show a popup,
/// creating a reusable component is recommended.
class PopupBuilder extends StatefulWidget {
  const PopupBuilder({
    required this.followerBuilder,
    required this.targetBuilder,
    required this.controller,
    this.targetAnchor = Alignment.bottomCenter,
    this.followerAnchor = Alignment.topCenter,
    this.flipWhenOverflow = true,
    this.moveWhenOverflow = true,
    this.enforceLeaderWidth = false,
    this.enforceLeaderHeight = false,
    super.key,
  });

  /// The target widget that the follower widget [followerBuilder] is positioned relative to.
  final WidgetBuilder targetBuilder;

  /// The widget that is positioned relative to the target widget [targetBuilder].
  final WidgetBuilder followerBuilder;

  /// {@macro popup.rendering.leader_anchor}
  final Alignment targetAnchor;

  /// {@macro popup.rendering.follower_anchor}
  final Alignment followerAnchor;

  /// The controller that is used to show/hide the overlay.
  ///
  /// If not provided, a controller is created automatically.
  final OverlayPortalController controller;

  /// {@macro popup.rendering.flip_when_overflow}
  final bool flipWhenOverflow;

  /// {@macro popup.rendering.move_when_overflow}
  final bool moveWhenOverflow;

  /// {@macro popup.rendering.enforce_leader_width}
  final bool enforceLeaderWidth;

  /// {@macro popup.rendering.enforce_leader_height}
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
  final _layerLink = PopupLayerLink();

  @override
  Widget build(BuildContext context) {
    final displayFeatureBounds = PopupBuilder.findDisplayFeatureBounds(
      MediaQuery.displayFeaturesOf(context),
    );

    return CompositedTransformPopupTarget(
      link: _layerLink,
      child: OverlayPortal(
        controller: widget.controller,
        child: widget.targetBuilder(context),
        overlayChildBuilder: (BuildContext context) => Center(
          child: CompositedTransformPopupFollower(
            link: _layerLink,
            displayFeatureBounds: displayFeatureBounds,
            enforceLeaderHeight: widget.enforceLeaderHeight,
            enforceLeaderWidth: widget.enforceLeaderWidth,
            flipWhenOverflow: widget.flipWhenOverflow,
            moveWhenOverflow: widget.moveWhenOverflow,
            targetAnchor: widget.targetAnchor,
            followerAnchor: widget.followerAnchor,
            child: widget.followerBuilder(context),
          ),
        ),
      ),
    );
  }
}
