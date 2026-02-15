import 'dart:ui' show Color, Locale;

import 'package:freezed_annotation/freezed_annotation.dart';

part 'general.freezed.dart';
part 'general.g.dart';

/// Possible theme modes for the application.
enum ThemeModeVO { light, dark, system }

/// Class that holds values used for constructing a theme for the app.
@freezed
abstract class GeneralSettings with _$GeneralSettings {
  const factory GeneralSettings({
    @Default(Locale('en')) @JsonKey(toJson: _localeToJson, fromJson: _localeFromJson) Locale locale,
    @Default(ThemeModeVO.system) ThemeModeVO themeMode,
    @Default(Color(0xFF6200EE))
    @JsonKey(toJson: _colorToARGB32, fromJson: _colorFromARGB32)
    Color seedColor,
  }) = _GeneralSettings;

  factory GeneralSettings.fromJson(Map<String, Object?> json) => _$GeneralSettingsFromJson(json);
}

String _localeToJson(Locale locale) => locale.toString();
Locale _localeFromJson(String json) => Locale(json);
int _colorToARGB32(Color color) => color.toARGB32();
Color _colorFromARGB32(int argb32) => Color(argb32);
