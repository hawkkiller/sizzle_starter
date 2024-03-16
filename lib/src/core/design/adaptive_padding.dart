import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:sizzle_starter/src/core/constant/config.dart';

/// {@template adaptive_padding}
/// ScaffoldPadding widget.
/// {@endtemplate}
class AdaptivePadding extends EdgeInsets {
  const AdaptivePadding._(final double value)
      : super.symmetric(horizontal: value);

  /// {@macro adaptive_padding}
  factory AdaptivePadding.of(BuildContext context) => AdaptivePadding._(
        math.max(
          (MediaQuery.sizeOf(context).width - Config.maxScreenLayoutWidth) / 2,
          16,
        ),
      );

  /// {@macro adaptive_padding}
  static Widget widget(BuildContext context, [Widget? child]) =>
      Padding(padding: AdaptivePadding.of(context), child: child);

  /// {@macro adaptive_padding}
  static Widget sliver(BuildContext context, [Widget? child]) =>
      SliverPadding(padding: AdaptivePadding.of(context), sliver: child);
}
