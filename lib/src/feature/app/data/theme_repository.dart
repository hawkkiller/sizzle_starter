import 'dart:async';

import 'package:sizzle_starter/src/feature/app/data/theme_datasource.dart';
import 'package:sizzle_starter/src/feature/app/model/app_theme.dart';

/// {@template theme_repository}
/// Repository which manages the current theme.
/// {@endtemplate}
abstract interface class ThemeRepository {
  /// Set theme
  Future<void> setTheme(AppTheme theme);

  /// Observe current theme changes
  AppTheme? loadAppThemeFromCache();
}

/// {@macro theme_repository}
final class ThemeRepositoryImpl implements ThemeRepository {
  final ThemeDataSource _dataSource;

  /// {@macro theme_repository}
  const ThemeRepositoryImpl(this._dataSource);

  @override
  Future<void> setTheme(AppTheme theme) => _dataSource.setTheme(theme);

  @override
  AppTheme? loadAppThemeFromCache() => _dataSource.loadThemeFromCache();
}
