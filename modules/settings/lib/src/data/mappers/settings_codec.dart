import 'dart:convert';
import 'dart:ui' show Locale;

import 'package:settings/settings.dart';
import 'package:settings/src/data/mappers/theme_configuration_codec.dart';

class SettingsCodec extends Codec<SettingsVO, Map<String, Object?>> {
  const SettingsCodec();

  @override
  Converter<Map<String, Object?>, SettingsVO> get decoder => const _SettingsDecoder();

  @override
  Converter<SettingsVO, Map<String, Object?>> get encoder => const _SettingsEncoder();
}

class _SettingsEncoder extends Converter<SettingsVO, Map<String, Object?>> {
  const _SettingsEncoder();

  static const _themeConfigurationCodec = ThemeConfigurationCodec();

  @override
  Map<String, Object?> convert(SettingsVO input) {
    return {
      'locale': input.locale?.languageCode,
      'textScale': input.textScale,
      'themeConfiguration': input.themeConfiguration != null 
          ? _themeConfigurationCodec.encode(input.themeConfiguration!)
          : null,
    };
  }
}

class _SettingsDecoder extends Converter<Map<String, Object?>, SettingsVO> {
  const _SettingsDecoder();

  static const _themeConfigurationCodec = ThemeConfigurationCodec();

  @override
  SettingsVO convert(Map<String, Object?> input) {
    final locale = input['locale'] as String?;
    final textScale = input['textScale'] as double?;
    final themeConfigurationMap = input['themeConfiguration'] as Map<String, Object?>?;

    ThemeConfigurationVO? themeConfiguration;
    if (themeConfigurationMap != null) {
      themeConfiguration = _themeConfigurationCodec.decode(themeConfigurationMap);
    }

    return SettingsVO(
      locale: locale != null ? Locale(locale) : null,
      textScale: textScale,
      themeConfiguration: themeConfiguration,
    );
  }
}
