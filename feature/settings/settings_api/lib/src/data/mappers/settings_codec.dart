import 'dart:convert';
import 'dart:ui' show Locale;

import 'package:settings_api/settings_api.dart';
import 'package:settings_api/src/data/mappers/theme_configuration_codec.dart';

class SettingsCodec extends Codec<Settings, Map<String, Object?>> {
  const SettingsCodec();

  @override
  Converter<Map<String, Object?>, Settings> get decoder => const _SettingsDecoder();

  @override
  Converter<Settings, Map<String, Object?>> get encoder => const _SettingsEncoder();
}

class _SettingsEncoder extends Converter<Settings, Map<String, Object?>> {
  const _SettingsEncoder();

  static const _themeConfigurationCodec = ThemeConfigurationCodec();

  @override
  Map<String, Object?> convert(Settings input) {
    return {
      'locale': input.locale?.languageCode,
      'textScale': input.textScale,
      'themeConfiguration': input.themeConfiguration != null
          ? _themeConfigurationCodec.encode(input.themeConfiguration!)
          : null,
    };
  }
}

class _SettingsDecoder extends Converter<Map<String, Object?>, Settings> {
  const _SettingsDecoder();

  static const _themeConfigurationCodec = ThemeConfigurationCodec();

  @override
  Settings convert(Map<String, Object?> input) {
    final locale = input['locale'] as String?;
    final textScale = input['textScale'] as double?;
    final themeConfigurationMap = input['themeConfiguration'] as Map<String, Object?>?;

    ThemeConfiguration? themeConfiguration;
    if (themeConfigurationMap != null) {
      themeConfiguration = _themeConfigurationCodec.decode(themeConfigurationMap);
    }

    return Settings(
      locale: locale != null ? Locale(locale) : null,
      textScale: textScale,
      themeConfiguration: themeConfiguration,
    );
  }
}
