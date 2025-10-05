import 'dart:convert';
import 'dart:ui' show Color;

import 'package:settings/settings.dart';

// TODO(Michael): update sizzle_lints to remove this lint
// ignore: prefer-prefixed-global-constants
const themeConfigurationCodec = ThemeConfigurationCodec();

/// {@template theme_configuration_codec}
/// Codec for [ThemeConfiguration]
/// {@endtemplate}
class ThemeConfigurationCodec extends Codec<ThemeConfiguration, Map<String, Object?>> {
  /// {@macro theme_configuration_codec}
  const ThemeConfigurationCodec();

  @override
  Converter<Map<String, Object?>, ThemeConfiguration> get decoder =>
      const _ThemeConfigurationDecoder();

  @override
  Converter<ThemeConfiguration, Map<String, Object?>> get encoder =>
      const _ThemeConfigurationEncoder();
}

class _ThemeConfigurationEncoder extends Converter<ThemeConfiguration, Map<String, Object?>> {
  const _ThemeConfigurationEncoder();

  @override
  Map<String, Object?> convert(ThemeConfiguration input) {
    return {
      'themeMode': input.themeMode.name,
      'seedColor': input.seedColor.toARGB32(),
    };
  }
}

class _ThemeConfigurationDecoder extends Converter<Map<String, Object?>, ThemeConfiguration> {
  const _ThemeConfigurationDecoder();

  @override
  ThemeConfiguration convert(Map<String, Object?> input) {
    if (input case {
      'themeMode': final String themeMode,
      'seedColor': final int seedColor,
    }) {
      return ThemeConfiguration(
        themeMode: ThemeModeVO.values.byName(themeMode),
        seedColor: Color(seedColor),
      );
    }

    throw FormatException('Invalid theme configuration format: $input');
  }
}
