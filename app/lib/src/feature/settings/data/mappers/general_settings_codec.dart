// TODO(Michael): update sizzle_lints to remove this lint
// ignore_for_file: prefer-prefixed-global-constants

import 'dart:ui' show Color;

import 'package:common/common.dart';

import 'package:sizzle_starter/src/feature/settings/domain/model/general.dart';

const generalSettingsCodec = GeneralSettingsCodec();

class GeneralSettingsCodec extends JsonMapCodec<GeneralSettings> {
  const GeneralSettingsCodec();

  @override
  GeneralSettings $decode(Map<String, Object?> input) {
    final themeMode = input['themeMode'] as String?;
    final seedColor = input['seedColor'] as Map<String, Object?>?;

    Color? seedColorValue;

    if (seedColor case {
      'r': final r as double,
      'g': final g as double,
      'b': final b as double,
      'a': final a as double,
    }) {
      seedColorValue = Color.from(alpha: a, red: r, green: g, blue: b);
    }

    const defaults = GeneralSettings();

    return GeneralSettings(
      themeMode: themeMode != null ? ThemeModeVO.values.byName(themeMode) : defaults.themeMode,
      seedColor: seedColorValue ?? defaults.seedColor,
    );
  }

  @override
  Map<String, Object?> $encode(GeneralSettings input) {
    return {
      'themeMode': input.themeMode.name,
      'seedColor': {
        'r': input.seedColor.r,
        'g': input.seedColor.g,
        'b': input.seedColor.b,
        'a': input.seedColor.a,
      },
    };
  }
}
