import 'dart:ui' show Color;

enum ThemeModeVO { light, dark, system }

/// Class that holds values used for constructing a theme for the app.
final class ThemeConfigurationVO {
  const ThemeConfigurationVO({required this.themeMode, required this.seedColor});

  final ThemeModeVO themeMode;
  final Color seedColor;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ThemeConfigurationVO && seedColor == other.seedColor && themeMode == other.themeMode;

  @override
  int get hashCode => Object.hash(seedColor, themeMode);
}
