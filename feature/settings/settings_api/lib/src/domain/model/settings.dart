import 'package:flutter/material.dart';
import 'package:settings_api/src/domain/model/theme_configuration.dart';

/// Settings for the app.
class Settings {
  const Settings({this.themeConfiguration, this.locale, this.textScale});

  final ThemeConfiguration? themeConfiguration;
  final Locale? locale;
  final double? textScale;

  static const initial = Settings(
    themeConfiguration: ThemeConfiguration(
      seedColor: Colors.blue,
      themeMode: ThemeModeVO.system,
    ),
    locale: Locale('en'),
    textScale: 1.0,
  );

  Settings copyWith({
    ThemeConfiguration? themeConfiguration,
    Locale? locale,
    double? textScale,
  }) => Settings(
    themeConfiguration: themeConfiguration ?? this.themeConfiguration,
    locale: locale ?? this.locale,
    textScale: textScale ?? this.textScale,
  );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Settings &&
        other.themeConfiguration == themeConfiguration &&
        other.locale == locale &&
        other.textScale == textScale;
  }

  @override
  int get hashCode => Object.hash(themeConfiguration, locale, textScale);
}
