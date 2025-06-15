import 'package:settings_domain/settings_domain.dart';
import 'package:settings_impl/src/datasources/settings_local_datasource.dart';

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
  
  @override
  Stream<Settings?> watchSettings() {
    return settingsLocalDatasource.watchSettings();
  }
}
