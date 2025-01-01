import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sizzle_starter/src/feature/settings/model/app_theme.dart';

void main() {
  group(
    'AppTheme',
    () {
      test(
        'should build theme with correct seed color for light theme',
        () {
          // arrange
          const theme = AppTheme.defaultTheme;
          // act
          final themeData = theme.buildThemeData(Brightness.light);
          // assert
          final expectedThemeData = ThemeData.from(
            colorScheme: ColorScheme.fromSeed(seedColor: theme.seed),
            useMaterial3: true,
          );
          expect(themeData, expectedThemeData);
          expect(themeData.brightness, Brightness.light);
        },
      );

      test(
        'should build theme with correct seed color for dark theme',
        () {
          // arrange
          const theme = AppTheme.defaultTheme;
          // act
          final themeData = theme.buildThemeData(Brightness.dark);
          // assert
          final expectedThemeData = ThemeData.from(
            colorScheme: ColorScheme.fromSeed(seedColor: theme.seed, brightness: Brightness.dark),
            useMaterial3: true,
          );
          expect(themeData, expectedThemeData);
          expect(themeData.brightness, Brightness.dark);
        },
      );
    },
  );
}
