import 'package:blaze_starter/src/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:theme_tailor_annotation/theme_tailor_annotation.dart';

part 'theme.tailor.dart';

// ignore: avoid_classes_with_only_static_members
@Tailor(
  themes: ['light', 'dark'],
  themeGetter: ThemeGetter.onBuildContext,
)
class $_AppTheme {
  // styles for texts
  static const h1Style = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
  );
  // colors
  static const light = AppColors.white();
  static const dark = AppColors.dark();
  // theme styles
  static List<TextStyle> h1 = [
    h1Style.copyWith(color: light.onPrimary),
    h1Style.copyWith(color: dark.onPrimary),
  ];
}
