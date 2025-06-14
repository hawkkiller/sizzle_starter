import 'package:settings/settings.dart';

abstract interface class SettingsRepository {
  Future<void> saveSettings(Settings settings);
  Future<Settings?> readSettings();
}
