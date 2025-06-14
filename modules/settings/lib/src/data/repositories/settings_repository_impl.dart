import 'package:settings/src/data/datasources/settings_local_datasource.dart';
import 'package:settings/src/domain/model/settings.dart';
import 'package:settings/src/domain/repositories/settings_repository.dart';

final class SettingsRepositoryImpl implements SettingsRepository {
  const SettingsRepositoryImpl({required this.settingsLocalDatasource});

  final SettingsLocalDatasource settingsLocalDatasource;

  @override
  Future<void> saveSettings(Settings settings) {
    return settingsLocalDatasource.saveSettings(settings);
  }

  @override
  Future<Settings?> readSettings() {
    return settingsLocalDatasource.readSettings();
  }
}
