import 'package:settings/src/data/datasources/settings_local_datasource.dart';
import 'package:settings/src/data/repositories/settings_repository_impl.dart';
import 'package:settings/src/domain/repositories/settings_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

SettingsRepository createSettingsRepository(SharedPreferencesAsync sharedPreferences) {
  return SettingsRepositoryImpl(
    settingsLocalDatasource: SettingsLocalDatasourceSharedPreferences(
      sharedPreferences: sharedPreferences,
    ),
  );
}
