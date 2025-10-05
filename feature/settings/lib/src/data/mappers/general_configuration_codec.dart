import 'dart:convert';
import 'dart:ui' show Locale;

import 'package:settings/src/domain/model/general_configuration.dart';

// TODO(Michael): update sizzle_lints to remove this lint
// ignore: prefer-prefixed-global-constants
const generalConfigurationCodec = GeneralConfigurationCodec();

/// {@template general_configuration_codec}
/// Codec for [GeneralConfiguration]
/// {@endtemplate}
class GeneralConfigurationCodec extends Codec<GeneralConfiguration, Map<String, Object?>> {
  /// {@macro general_configuration_codec}
  const GeneralConfigurationCodec();

  @override
  Converter<Map<String, Object?>, GeneralConfiguration> get decoder =>
      const _GeneralConfigurationDecoder();

  @override
  Converter<GeneralConfiguration, Map<String, Object?>> get encoder =>
      const _GeneralConfigurationEncoder();
}

class _GeneralConfigurationEncoder extends Converter<GeneralConfiguration, Map<String, Object?>> {
  const _GeneralConfigurationEncoder();

  @override
  Map<String, Object?> convert(GeneralConfiguration input) {
    return {
      'locale': '${input.locale.languageCode}_${input.locale.countryCode ?? ''}',
    };
  }
}

class _GeneralConfigurationDecoder extends Converter<Map<String, Object?>, GeneralConfiguration> {
  const _GeneralConfigurationDecoder();

  @override
  GeneralConfiguration convert(Map<String, Object?> input) {
    if (input case {'locale': final String localeString}) {
      final parts = localeString.split('_');
      final languageCode = parts[0];
      final countryCode = parts.length > 1 && parts[1].isNotEmpty ? parts[1] : null;

      return GeneralConfiguration(locale: Locale(languageCode, countryCode));
    }

    throw FormatException('Invalid general configuration format: $input');
  }
}
