import 'dart:async';

import 'package:common/common.dart';
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

  SharedPreferencesColumnJson get sharedPreferencesColumnJson => SharedPreferencesColumnJson(
    sharedPreferences: sharedPreferences,
    key: 'settings',
  );

  @override
  Future<void> save(Settings settings) async {
    final settingsMap = settingsCodec.encode(settings);

    await sharedPreferencesColumnJson.set(settingsMap);
  }

  @override
  Future<Settings> read() async {
    final settingsMap = await sharedPreferencesColumnJson.read();
    if (settingsMap == null) return const Settings();

    return settingsCodec.decode(settingsMap);
  }
}
