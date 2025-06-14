import 'dart:convert';

import 'package:settings/settings.dart';
import 'package:settings/src/data/mappers/settings_codec.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract interface class SettingsLocalDatasource {
  Future<SettingsVO?> readSettings();
  Future<void> saveSettings(SettingsVO settings);
}

final class SettingsLocalDatasourceSharedPreferences implements SettingsLocalDatasource {
  const SettingsLocalDatasourceSharedPreferences({
    required this.sharedPreferences,
    this.settingsCodec = const SettingsCodec(),
  });

  final SharedPreferencesAsync sharedPreferences;
  final SettingsCodec settingsCodec;

  @override
  Future<void> saveSettings(SettingsVO settings) async {
    final settingsMap = settingsCodec.encode(settings);
    await sharedPreferences.setString('settings', jsonEncode(settingsMap));
  }

  @override
  Future<SettingsVO?> readSettings() async {
    final settingsMap = await sharedPreferences.getString('settings');
    if (settingsMap == null) return null;

    return settingsCodec.decode(jsonDecode(settingsMap) as Map<String, Object?>);
  }
}
