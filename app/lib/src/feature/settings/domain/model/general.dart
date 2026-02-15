import 'dart:ui' show Color, Locale;

/// Possible theme modes for the application.
enum ThemeModeVO { light, dark, system }

/// Class that holds values used for constructing a theme for the app.
final class GeneralSettings {
  const GeneralSettings({
    this.locale = const Locale('en'),
    this.themeMode = ThemeModeVO.system,
    this.seedColor = const Color(0xFF6200EE),
  });

  final ThemeModeVO themeMode;
  final Color seedColor;
  final Locale locale;

  GeneralSettings copyWith({ThemeModeVO? themeMode, Color? seedColor, Locale? locale}) {
    return GeneralSettings(
      themeMode: themeMode ?? this.themeMode,
      seedColor: seedColor ?? this.seedColor,
      locale: locale ?? this.locale,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GeneralSettings &&
          seedColor == other.seedColor &&
          themeMode == other.themeMode &&
          locale == other.locale;

  @override
  int get hashCode => Object.hash(seedColor, themeMode, locale);
}
