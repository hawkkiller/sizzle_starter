import 'dart:async';
import 'dart:convert';

import 'package:settings/settings.dart';
import 'package:settings/src/data/mappers/settings_codec.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract interface class SettingsLocalDatasource {
  Future<Settings> read();
  Future<void> save(Settings settings);
}

final class SettingsLocalDatasourceSharedPreferences implements SettingsLocalDatasource {
  const SettingsLocalDatasourceSharedPreferences({
    required this.sharedPreferences,
    this.settingsCodec = const SettingsCodec(),
  });

  final SharedPreferencesAsync sharedPreferences;
  final SettingsCodec settingsCodec;

  @override
  Future<void> save(Settings settings) async {
    final settingsMap = settingsCodec.encode(settings);
    await sharedPreferences.setString('settings', jsonEncode(settingsMap));
  }

  @override
  Future<Settings> read() async {
    final settingsMap = await sharedPreferences.getString('settings');
    if (settingsMap == null) return const Settings();

    return settingsCodec.decode(jsonDecode(settingsMap) as Map<String, Object?>);
  }
}
