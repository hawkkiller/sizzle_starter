import 'dart:convert';
import 'dart:ui' show Color;

import 'package:settings/settings.dart';

/// {@template theme_configuration_codec}
/// Codec for [ThemeConfigurationVO]
/// {@endtemplate}
class ThemeConfigurationCodec extends Codec<ThemeConfigurationVO, Map<String, Object?>> {
  /// {@macro theme_configuration_codec}
  const ThemeConfigurationCodec();

  @override
  Converter<Map<String, Object?>, ThemeConfigurationVO> get decoder => const _ThemeConfigurationDecoder();

  @override
  Converter<ThemeConfigurationVO, Map<String, Object?>> get encoder => const _ThemeConfigurationEncoder();
}

class _ThemeConfigurationEncoder extends Converter<ThemeConfigurationVO, Map<String, Object?>> {
  const _ThemeConfigurationEncoder();

  @override
  Map<String, Object?> convert(ThemeConfigurationVO input) {
    return {
      'themeMode': input.themeMode.name,
      'seedColor': input.seedColor.toARGB32(),
    };
  }
}

class _ThemeConfigurationDecoder extends Converter<Map<String, Object?>, ThemeConfigurationVO> {
  const _ThemeConfigurationDecoder();

  @override
  ThemeConfigurationVO convert(Map<String, Object?> input) {
    if (input case {
      'themeMode': final String themeMode,
      'seedColor': final int seedColor,
    }) {
      return ThemeConfigurationVO(
        themeMode: ThemeModeVO.values.byName(themeMode),
        seedColor: Color(seedColor),
      );
    }
    
    throw FormatException('Invalid theme configuration format: $input');
  }
}
