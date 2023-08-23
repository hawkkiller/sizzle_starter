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

  @pragma('vm:prefer-inline')
  static Color? _colorOrNull(int? value) => value != null ? Color(value) : null;

  @override
  AppTheme convert(String input) {
    final json = jsonDecode(input) as Map<String, Object?>;

    if (json
        case {
          'type': final String type,
          'colorScheme': {
            'brightness': final String? brightness,
            'primary': final int? primary,
            'primaryContainer': final int? primaryContainer,
            'onPrimary': final int? onPrimary,
            'onPrimaryContainer': final int? onPrimaryContainer,
            'secondary': final int? secondary,
            'secondaryContainer': final int? secondaryContainer,
            'onSecondary': final int? onSecondary,
            'onSecondaryContainer': final int? onSecondaryContainer,
            'tertiary': final int? tertiary,
            'onTertiary': final int? onTertiary,
            'tertiaryContainer': final int? tertiaryContainer,
            'onTertiaryContainer': final int? onTertiaryContainer,
            'surface': final int? surface,
            'onSurface': final int? onSurface,
            'background': final int? background,
            'onBackground': final int? onBackground,
            'error': final int? error,
            'onError': final int? onError,
            'errorContainer': final int? errorContainer,
            'onErrorContainer': final int? onErrorContainer,
            'surfaceVariant': final int? surfaceVariant,
            'onSurfaceVariant': final int? onSurfaceVariant,
            'outline': final int? outline,
            'outlineVariant': final int? outlineVariant,
            'shadow': final int? shadow,
            'scrim': final int? scrim,
            'inverseSurface': final int? inverseSurface,
            'onInverseSurface': final int? onInverseSurface,
            'inversePrimary': final int? inversePrimary,
            'surfaceTint': final int? surfaceTint,
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
          secondary: Color(secondary),
          surface: Color(surface),
          background: Color(background),
          error: Color(error),
          onPrimary: Color(onPrimary),
          onSecondary: Color(onSecondary),
          onSurface: Color(onSurface),
          onBackground: Color(onBackground),
          onError: Color(onError),
          primaryContainer: _colorOrNull(primaryContainer),
          secondaryContainer: _colorOrNull(secondaryContainer),
          errorContainer: _colorOrNull(errorContainer),
          onPrimaryContainer: _colorOrNull(onPrimaryContainer),
          onSecondaryContainer: _colorOrNull(onSecondaryContainer),
          onErrorContainer: _colorOrNull(onErrorContainer),
          tertiary: _colorOrNull(tertiary),
          onTertiary: _colorOrNull(onTertiary),
          tertiaryContainer: _colorOrNull(tertiaryContainer),
          onTertiaryContainer: _colorOrNull(onTertiaryContainer),
          surfaceVariant: _colorOrNull(surfaceVariant),
          onSurfaceVariant: _colorOrNull(onSurfaceVariant),
          outline: _colorOrNull(outline),
          outlineVariant: _colorOrNull(outlineVariant),
          shadow: _colorOrNull(shadow),
          scrim: _colorOrNull(scrim),
          inverseSurface: _colorOrNull(inverseSurface),
          onInverseSurface: _colorOrNull(onInverseSurface),
          inversePrimary: _colorOrNull(inversePrimary),
          surfaceTint: _colorOrNull(surfaceTint),
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
        'brightness': input.colorScheme?.brightness.name,
        'primary': input.colorScheme?.primary.value,
        'onPrimary': input.colorScheme?.onPrimary.value,
        'primaryContainer': input.colorScheme?.primaryContainer.value,
        'onPrimaryContainer': input.colorScheme?.onPrimaryContainer.value,
        'secondary': input.colorScheme?.secondary.value,
        'onSecondary': input.colorScheme?.onSecondary.value,
        'secondaryContainer': input.colorScheme?.secondaryContainer.value,
        'onSecondaryContainer': input.colorScheme?.onSecondaryContainer.value,
        'surface': input.colorScheme?.surface.value,
        'onSurface': input.colorScheme?.onSurface.value,
        'background': input.colorScheme?.background.value,
        'onBackground': input.colorScheme?.onBackground.value,
        'error': input.colorScheme?.error.value,
        'onError': input.colorScheme?.onError.value,
        'errorContainer': input.colorScheme?.errorContainer.value,
        'onErrorContainer': input.colorScheme?.onErrorContainer.value,
        'tertiary': input.colorScheme?.tertiary.value,
        'onTertiary': input.colorScheme?.onTertiary.value,
        'tertiaryContainer': input.colorScheme?.tertiaryContainer.value,
        'onTertiaryContainer': input.colorScheme?.onTertiaryContainer.value,
        'surfaceVariant': input.colorScheme?.surfaceVariant.value,
        'onSurfaceVariant': input.colorScheme?.onSurfaceVariant.value,
        'outline': input.colorScheme?.outline.value,
        'outlineVariant': input.colorScheme?.outlineVariant.value,
        'shadow': input.colorScheme?.shadow.value,
        'scrim': input.colorScheme?.scrim.value,
        'inverseSurface': input.colorScheme?.inverseSurface.value,
        'onInverseSurface': input.colorScheme?.onInverseSurface.value,
        'inversePrimary': input.colorScheme?.inversePrimary.value,
        'surfaceTint': input.colorScheme?.surfaceTint.value,
      },
    };

    return jsonEncode(json);
  }
}
