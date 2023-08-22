import 'dart:ui';

import 'package:shared_preferences/shared_preferences.dart';

/// {@template locale_datasource}
/// [LocaleDataSource] is an entry point to the locale data layer.
///
/// This is used to set and get locale.
/// {@endtemplate}
abstract interface class LocaleDataSource {
  /// Set locale
  Future<void> setLocale(Locale locale);

  /// Get current locale from cache
  Locale? loadLocaleFromCache();
}

/// {@macro locale_datasource}
final class LocaleDataSourceImpl implements LocaleDataSource {
  final SharedPreferences _sharedPreferences;

  /// {@macro locale_datasource}
  const LocaleDataSourceImpl({
    required SharedPreferences sharedPreferences,
  }) : _sharedPreferences = sharedPreferences;

  static const _prefix = 'locale';

  @override
  Future<void> setLocale(Locale locale) async {
    await _sharedPreferences.setString(
      '$_prefix.locale',
      locale.toString(),
    );

    return;
  }

  @override
  Locale? loadLocaleFromCache() {
    final locale = _sharedPreferences.getString('$_prefix.locale');

    if (locale != null) {
      final localeParts = locale.split('_');
      return Locale.fromSubtags(
        languageCode: localeParts[0],
        countryCode: localeParts.length > 1 ? localeParts[1] : null,
      );
    }

    return null;
  }
}
