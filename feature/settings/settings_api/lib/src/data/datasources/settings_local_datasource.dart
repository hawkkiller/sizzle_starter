import 'dart:async';
import 'dart:convert';

import 'package:settings_api/settings_api.dart';
import 'package:settings_api/src/data/mappers/settings_codec.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract interface class SettingsLocalDatasource {
  Future<Settings?> readSettings();
  Future<void> saveSettings(Settings settings);
  Stream<Settings?> watchSettings();
}

final class SettingsLocalDatasourceSharedPreferences implements SettingsLocalDatasource {
  SettingsLocalDatasourceSharedPreferences({
    required this.sharedPreferences,
    this.settingsCodec = const SettingsCodec(),
  });

  final SharedPreferencesAsync sharedPreferences;
  final SettingsCodec settingsCodec;
  final _settingsController = StreamController<Settings?>.broadcast();

  @override
  Future<void> saveSettings(Settings settings) async {
    final settingsMap = settingsCodec.encode(settings);
    await sharedPreferences.setString('settings', jsonEncode(settingsMap));
    _settingsController.add(settings);
  }

  @override
  Future<Settings?> readSettings() async {
    final settingsMap = await sharedPreferences.getString('settings');
    if (settingsMap == null) return null;

    return settingsCodec.decode(jsonDecode(settingsMap) as Map<String, Object?>);
  }

  @override
  Stream<Settings?> watchSettings() => _settingsController.stream;
}
