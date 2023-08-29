import 'dart:async';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizzle_starter/src/core/utils/codecs/color_scheme_codec.dart';
import 'package:sizzle_starter/src/feature/app/model/app_theme.dart';

/// {@template theme_datasource}
/// [ThemeDataSource] is an entry point to the theme data layer.
///
/// This is used to set and get theme.
/// {@endtemplate}
abstract interface class ThemeDataSource {
  /// Set theme
  Future<void> setTheme(AppTheme theme);

  /// Get current theme from cache
  AppTheme? loadThemeFromCache();
}

/// {@macro theme_datasource}
final class ThemeDataSourceImpl implements ThemeDataSource {
  final SharedPreferences _sharedPreferences;

  /// {@macro theme_datasource}
  const ThemeDataSourceImpl({
    required SharedPreferences sharedPreferences,
  }) : _sharedPreferences = sharedPreferences;

  static const _prefix = 'theme_';

  @override
  Future<void> setTheme(AppTheme theme) async {
    await _sharedPreferences.setString(
      '$_prefix.theme',
      jsonEncode(_themeCodec.encode(theme)),
    );

    return;
  }

  @override
  AppTheme? loadThemeFromCache() {
    final theme = _sharedPreferences.getString('$_prefix.theme');

    if (theme != null) {
      final json = jsonDecode(theme) as Map<String, Object?>;
      return _themeCodec.decode(json);
    }

    return null;
  }
}

const _themeCodec = _AppThemeCodec();

final class _AppThemeCodec extends Codec<AppTheme, Map<String, Object?>> {
  const _AppThemeCodec();

  @override
  Converter<Map<String, Object?>, AppTheme> get decoder =>
      const _AppThemeDecoder();

  @override
  Converter<AppTheme, Map<String, Object?>> get encoder =>
      const _AppThemeEncoder();
}

final class _AppThemeDecoder extends Converter<Map<String, Object?>, AppTheme> {
  const _AppThemeDecoder();

  @override
  AppTheme convert(Map<String, Object?> json) {
    final type = json['type'] as String?;

    final colorScheme = json['colorScheme'] as Map<String, Object?>?;

    if (type == null) throw FormatException('Invalid AppTheme JSON $json');

    final themeType = AppColorSchemeType.fromString(type);

    if (colorScheme != null) {
      final scheme = colorSchemeCodec.decode(colorScheme);
      return AppTheme.create(
        type: themeType,
        colorScheme: scheme,
      );
    }

    return AppTheme.create(
      type: themeType,
    );
  }
}

final class _AppThemeEncoder extends Converter<AppTheme, Map<String, Object?>> {
  const _AppThemeEncoder();

  @override
  Map<String, Object?> convert(AppTheme input) {
    final colorScheme = input.colorScheme;
    final json = {
      'type': input.type.toString(),
      if (colorScheme != null)
        'colorScheme': colorSchemeCodec.encode(colorScheme),
    };

    return json;
  }
}
