import 'dart:async';
import 'dart:ui';

import 'package:sizzle_starter/src/core/utils/preferences_dao.dart';
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
final class ThemeDataSourceImpl extends PreferencesDao
    implements ThemeDataSource {
  /// {@macro theme_datasource}
  ThemeDataSourceImpl(super._sharedPreferences);

  PreferencesEntry<int> get _seedColor => intEntry('theme.seed_color');

  PreferencesEntry<String> get _colorSchemeType => stringEntry(
        'theme.color_scheme_type',
      );

  @override
  Future<void> setTheme(AppTheme theme) async {
    await _seedColor.setOrRemove(theme.seed?.value);
    await _colorSchemeType.setOrRemove(theme.type.toString());

    return;
  }

  @override
  AppTheme? loadThemeFromCache() {
    final seedColor = _seedColor.read();

    final type = _colorSchemeType.read();

    if (type == null) return null;

    return AppTheme(
      seed: seedColor != null ? Color(seedColor) : null,
      type: AppThemeMode.fromString(type),
    );
  }
}
