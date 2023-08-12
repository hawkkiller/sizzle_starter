import 'package:flutter/material.dart';

/// Default Material 3 light [ThemeData].
final defaultLightThemeData = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.blue,
  ),
  brightness: Brightness.light,
  useMaterial3: true,
);

/// Default Material 3 dark [ThemeData].
final defaultDarkThemeData = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.blue,
    brightness: Brightness.dark,
  ),
  brightness: Brightness.dark,
  useMaterial3: true,
);
