import 'dart:ui';

import 'package:sizzle_starter/src/core/utils/preferences_dao.dart';

/// {@template locale_datasource}
/// [LocaleDataSource] is an entry point to the locale data layer.
///
/// This is used to set and get locale.
/// {@endtemplate}
abstract interface class LocaleDataSource {
  /// Set locale
  Future<void> setLocale(Locale locale);

  /// Get current locale from cache
  Future<Locale?> getLocale();
}

/// {@macro locale_datasource}
final class LocaleDataSourceLocal extends PreferencesDao implements LocaleDataSource {
  /// {@macro locale_datasource}
  const LocaleDataSourceLocal({required super.sharedPreferences});

  PreferencesEntry<String> get _languageCode => stringEntry(
        'settings.locale.languageCode',
      );
  PreferencesEntry<String> get _scriptCode => stringEntry(
        'settings.locale.scriptCode',
      );
  PreferencesEntry<String> get _countryCode => stringEntry(
        'settings.locale.countryCode',
      );

  @override
  Future<void> setLocale(Locale locale) async {
    await _languageCode.set(locale.languageCode);
    final scriptCode = locale.scriptCode;
    final countryCode = locale.countryCode;

    if (scriptCode != null) {
      await _scriptCode.set(scriptCode);
    }
    if (countryCode != null) {
      await _countryCode.set(countryCode);
    }
  }

  @override
  Future<Locale?> getLocale() async {
    final languageCode = _languageCode.read();
    final scriptCode = _scriptCode.read();
    final countryCode = _countryCode.read();

    if (languageCode == null) return null;

    return Locale.fromSubtags(
      languageCode: languageCode,
      scriptCode: scriptCode,
      countryCode: countryCode,
    );
  }
}
