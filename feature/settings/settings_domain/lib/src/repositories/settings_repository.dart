import 'package:settings_domain/src/model/settings.dart';

abstract interface class SettingsRepository {
  Stream<Settings?> watchSettings();
  Future<void> saveSettings(Settings settings);
  Future<Settings?> readSettings();
}
