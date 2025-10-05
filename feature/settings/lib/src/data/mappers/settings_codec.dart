import 'dart:convert';

import 'package:settings/settings.dart';
import 'package:settings/src/data/mappers/general_configuration_codec.dart';
import 'package:settings/src/data/mappers/theme_configuration_codec.dart';
import 'package:settings/src/domain/model/general_configuration.dart';

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
      'general': generalConfigurationCodec.encode(input.general),
      'theme': themeConfigurationCodec.encode(input.theme),
    };
  }
}

class _SettingsDecoder extends Converter<Map<String, Object?>, Settings> {
  const _SettingsDecoder();

  @override
  Settings convert(Map<String, Object?> input) {
    final generalMap = input['general'] as Map<String, Object?>?;
    final themeMap = input['themeConfiguration'] as Map<String, Object?>?;

    ThemeConfiguration? theme;
    GeneralConfiguration? general;

    if (themeMap != null) {
      theme = themeConfigurationCodec.decode(themeMap);
    }

    if (generalMap != null) {
      general = generalConfigurationCodec.decode(generalMap);
    }

    return Settings(
      general: general ?? const GeneralConfiguration(),
      theme: theme ?? const ThemeConfiguration(),
    );
  }
}
