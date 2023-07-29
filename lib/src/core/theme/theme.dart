import 'package:flutter/material.dart';

final $lightThemeData = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.blue,
  ),
  brightness: Brightness.light,
  useMaterial3: true,
);

final $darkThemeData = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.blue,
    brightness: Brightness.dark,
  ),
  brightness: Brightness.dark,
  useMaterial3: true,
);
