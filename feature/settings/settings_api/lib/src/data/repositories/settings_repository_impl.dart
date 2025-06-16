import 'package:settings_api/settings_api.dart';
import 'package:settings_api/src/data/datasources/settings_local_datasource.dart';

final class SettingsRepositoryImpl implements SettingsRepository {
  const SettingsRepositoryImpl({required this.settingsLocalDatasource});

  final SettingsLocalDatasource settingsLocalDatasource;

  @override
  Future<void> save(Settings settings) {
    return settingsLocalDatasource.saveSettings(settings);
  }

  @override
  Future<Settings?> read() {
    return settingsLocalDatasource.readSettings();
  }
  
  @override
  Stream<Settings?> watch() {
    return settingsLocalDatasource.watchSettings();
  }
}
