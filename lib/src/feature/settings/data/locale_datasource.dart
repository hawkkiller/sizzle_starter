import 'dart:ui';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizzle_starter/src/core/utils/persisted_entry.dart';

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
final class LocaleDataSourceLocal implements LocaleDataSource {
  /// {@macro locale_datasource}
  LocaleDataSourceLocal({required this.sharedPreferences});

  /// The instance of [SharedPreferences] used to read and write values.
  final SharedPreferencesAsync sharedPreferences;

  late final _languageCode = StringPreferencesEntry(
    sharedPreferences: sharedPreferences,
    key: 'settings.locale.languageCode',
  );

  late final _scriptCode = StringPreferencesEntry(
    sharedPreferences: sharedPreferences,
    key: 'settings.locale.scriptCode',
  );

  late final _countryCode = StringPreferencesEntry(
    sharedPreferences: sharedPreferences,
    key: 'settings.locale.countryCode',
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
    final languageCode = await _languageCode.read();
    final scriptCode = await _scriptCode.read();
    final countryCode = await _countryCode.read();

    if (languageCode == null) return null;

    return Locale.fromSubtags(
      languageCode: languageCode,
      scriptCode: scriptCode,
      countryCode: countryCode,
    );
  }
}
