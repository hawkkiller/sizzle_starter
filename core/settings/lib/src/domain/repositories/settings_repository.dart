import 'package:settings/settings.dart';

abstract interface class SettingsRepository {
  Stream<Settings?> watchSettings();
  Future<void> saveSettings(Settings settings);
  Future<Settings?> readSettings();
}
