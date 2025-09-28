import 'dart:convert';
import 'dart:ui' show Locale;

import 'package:settings_api/settings_api.dart';
import 'package:settings_api/src/data/mappers/theme_configuration_codec.dart';

const _kConfigurationCodec = ThemeConfigurationCodec();

class SettingsCodec extends Codec<Settings, Map<String, Object?>> {
  const SettingsCodec();

  @override
  Converter<Map<String, Object?>, Settings> get decoder => const _SettingsDecoder();

  @override
  Converter<Settings, Map<String, Object?>> get encoder => const _SettingsEncoder();
}

class _SettingsEncoder extends Converter<Settings, Map<String, Object?>> {
  const _SettingsEncoder();

  @override
  Map<String, Object?> convert(Settings input) {
    return {
      'locale': input.locale?.languageCode,
      'textScale': input.textScale,
      'themeConfiguration': _kConfigurationCodec.encode(input.themeConfiguration),
    };
  }
}

class _SettingsDecoder extends Converter<Map<String, Object?>, Settings> {
  const _SettingsDecoder();

  @override
  Settings convert(Map<String, Object?> input) {
    final locale = input['locale'] as String?;
    final textScale = input['textScale'] as double?;
    final themeConfigurationMap = input['themeConfiguration'] as Map<String, Object?>?;

    ThemeConfiguration? themeConfiguration;
    if (themeConfigurationMap != null) {
      themeConfiguration = _kConfigurationCodec.decode(themeConfigurationMap);
    }

    return Settings(
      locale: locale != null ? Locale(locale) : null,
      textScale: textScale,
      themeConfiguration: themeConfiguration ?? const ThemeConfiguration(),
    );
  }
}
