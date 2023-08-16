import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  /// {@macro theme_datasource}
  const ThemeDataSourceImpl({
    required SharedPreferences sharedPreferences,
  }) : _sharedPreferences = sharedPreferences;

  final SharedPreferences _sharedPreferences;

  static const _prefix = 'theme_';

  @override
  Future<void> setTheme(AppTheme theme) async {
    await _sharedPreferences.setString(
      '$_prefix.theme',
      _themeCodec.encode(theme),
    );

    return;
  }

  @override
  AppTheme? loadThemeFromCache() {
    final theme = _sharedPreferences.getString('$_prefix.theme');

    if (theme != null) {
      return _themeCodec.decode(theme);
    }

    return null;
  }
}

const _themeCodec = _AppThemeCodec();

final class _AppThemeCodec extends Codec<AppTheme, String> {
  const _AppThemeCodec();

  @override
  Converter<String, AppTheme> get decoder => const _AppThemeDecoder();

  @override
  Converter<AppTheme, String> get encoder => const _AppThemeEncoder();
}

final class _AppThemeDecoder extends Converter<String, AppTheme> {
  const _AppThemeDecoder();

  @override
  AppTheme convert(String input) {
    final json = jsonDecode(input) as Map<String, dynamic>;

    if (json
        case {
          'type': final String type,
          'colorScheme': {
            'primary': final int? primary,
            'primaryContainer': final int? primaryContainer,
            'secondary': final int? secondary,
            'secondaryContainer': final int? secondaryContainer,
            'surface': final int? surface,
            'background': final int? background,
            'error': final int? error,
            'errorContainer': final int? errorContainer,
            'onPrimary': final int? onPrimary,
            'onPrimaryContainer': final int? onPrimaryContainer,
            'onSecondary': final int? onSecondary,
            'onSecondaryContainer': final int? onSecondaryContainer,
            'onSurface': final int? onSurface,
            'onBackground': final int? onBackground,
            'onError': final int? onError,
            'brightness': final String? brightness,
          },
        }) {
      if (primary == null ||
          secondary == null ||
          surface == null ||
          background == null ||
          error == null ||
          onPrimary == null ||
          onSecondary == null ||
          onSurface == null ||
          onBackground == null ||
          onError == null ||
          brightness == null) {
        return AppTheme.create(
          type: AppColorSchemeType.fromString(type),
        );
      }
      return AppTheme.create(
        type: AppColorSchemeType.fromString(type),
        colorScheme: ColorScheme(
          primary: Color(primary),
          primaryContainer:
              primaryContainer != null ? Color(primaryContainer) : null,
          secondary: Color(secondary),
          secondaryContainer:
              secondaryContainer != null ? Color(secondaryContainer) : null,
          surface: Color(surface),
          background: Color(background),
          error: Color(error),
          errorContainer: errorContainer != null ? Color(errorContainer) : null,
          onPrimary: Color(onPrimary),
          onPrimaryContainer:
              onPrimaryContainer != null ? Color(onPrimaryContainer) : null,
          onSecondary: Color(onSecondary),
          onSecondaryContainer:
              onSecondaryContainer != null ? Color(onSecondaryContainer) : null,
          onSurface: Color(onSurface),
          onBackground: Color(onBackground),
          onError: Color(onError),
          brightness: switch (brightness) {
            'light' => Brightness.light,
            'dark' => Brightness.dark,
            _ => throw Exception('Unknown brightness: $brightness'),
          },
        ),
      );
    }
    throw Exception('Unknown json: $json');
  }
}

final class _AppThemeEncoder extends Converter<AppTheme, String> {
  const _AppThemeEncoder();

  @override
  String convert(AppTheme input) {
    final json = {
      'type': input.type.toString(),
      'colorScheme': {
        'primary': input.colorScheme?.primary.value,
        'primaryContainer': input.colorScheme?.primaryContainer.value,
        'secondary': input.colorScheme?.secondary.value,
        'secondaryContainer': input.colorScheme?.secondaryContainer.value,
        'surface': input.colorScheme?.surface.value,
        'background': input.colorScheme?.background.value,
        'error': input.colorScheme?.error.value,
        'errorContainer': input.colorScheme?.errorContainer.value,
        'onPrimary': input.colorScheme?.onPrimary.value,
        'onPrimaryContainer': input.colorScheme?.onPrimaryContainer.value,
        'onSecondary': input.colorScheme?.onSecondary.value,
        'onSecondaryContainer': input.colorScheme?.onSecondaryContainer.value,
        'onSurface': input.colorScheme?.onSurface.value,
        'onBackground': input.colorScheme?.onBackground.value,
        'onError': input.colorScheme?.onError.value,
        'brightness': input.colorScheme?.brightness.name,
      }
    };

    return jsonEncode(json);
  }
}
