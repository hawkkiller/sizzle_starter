import 'dart:ui' show Color;

enum ThemeModeVO { light, dark, system }

/// Class that holds values used for constructing a theme for the app.
final class ThemeConfiguration {
  const ThemeConfiguration({required this.themeMode, required this.seedColor});

  final ThemeModeVO themeMode;
  final Color seedColor;

  ThemeConfiguration copyWith({ThemeModeVO? themeMode, Color? seedColor}) {
    return ThemeConfiguration(
      themeMode: themeMode ?? this.themeMode,
      seedColor: seedColor ?? this.seedColor,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ThemeConfiguration && seedColor == other.seedColor && themeMode == other.themeMode;

  @override
  int get hashCode => Object.hash(seedColor, themeMode);
}
