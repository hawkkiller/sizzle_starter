import 'dart:async';

import 'package:common_utils/common_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:sizzle_starter/src/feature/settings/domain/model/settings.dart';
import 'package:sizzle_starter/src/feature/settings/domain/repositories/settings_repository.dart';

final class SettingsRepositoryImpl implements SettingsRepository {
  const SettingsRepositoryImpl({required this.sharedPreferences});

  final SharedPreferencesAsync sharedPreferences;

  SharedPreferencesColumnJson get _column => SharedPreferencesColumnJson(
    sharedPreferences: sharedPreferences,
    key: 'settings',
  );

  @override
  Future<void> save(Settings settings) async {
    await _column.set(settings.toJson());
  }

  @override
  Future<Settings> read() async {
    final settingsMap = await _column.read();
    if (settingsMap == null) return const Settings();

    return Settings.fromJson(settingsMap);
  }
}
