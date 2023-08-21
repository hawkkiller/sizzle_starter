import 'dart:ui';

import 'package:sizzle_starter/src/feature/app/data/locale_datasource.dart';

/// {@template locale_datasource}
/// This is used to set and get locale.
/// {@endtemplate}
abstract interface class LocaleRepository {
  /// Set locale
  Future<void> setLocale(Locale locale);

  /// Get current locale from cache
  Locale? loadLocaleFromCache();
}

/// {@macro locale_datasource}
final class LocaleRepositoryImpl implements LocaleRepository {
  final LocaleDataSource _localeDataSource;

  /// {@macro locale_datasource}
  const LocaleRepositoryImpl(this._localeDataSource);

  @override
  Future<void> setLocale(Locale locale) => _localeDataSource.setLocale(locale);

  @override
  Locale? loadLocaleFromCache() => _localeDataSource.loadLocaleFromCache();
}
