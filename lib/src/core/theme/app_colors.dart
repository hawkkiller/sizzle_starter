import 'package:flutter/material.dart';

abstract class AppColors {
  const AppColors();

  const factory AppColors.white() = _AppColorsWhite;

  const factory AppColors.dark() = _AppColorsDark;

  abstract final Color primary;

  abstract final Color onPrimary;

  abstract final Color onSecondary;
}

class _AppColorsWhite implements AppColors {
  const _AppColorsWhite();

  @override
  Color get primary => Colors.white;

  @override
  Color get onPrimary => Colors.black;

  @override
  Color get onSecondary => Colors.white;
}

class _AppColorsDark implements AppColors {
  const _AppColorsDark();

  @override
  Color get primary => Colors.black87;

  @override
  Color get onPrimary => Colors.white;

  @override
  Color get onSecondary => Colors.black;
}
