import 'package:settings/settings.dart';

abstract interface class SettingsRepository {
  Future<void> saveSettings(SettingsVO settings);
  Future<SettingsVO?> readSettings();
}
