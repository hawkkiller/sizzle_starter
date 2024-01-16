import 'dart:ui';

import 'package:sizzle_starter/src/feature/settings/data/locale_datasource.dart';

/// Repository that manages locale information
abstract interface class LocaleRepository {
  /// Get locale
  Future<Locale?> getLocale();

  /// Set locale
  Future<void> setLocale(Locale locale);
}

/// Locale repository implementation
final class LocaleRepositoryImpl implements LocaleRepository {
  /// Create locale repository
  const LocaleRepositoryImpl({required LocaleDataSource localeDataSource})
      : _localeDataSource = localeDataSource;

  final LocaleDataSource _localeDataSource;

  @override
  Future<Locale?> getLocale() => _localeDataSource.getLocale();

  @override
  Future<void> setLocale(Locale locale) => _localeDataSource.setLocale(locale);
}
