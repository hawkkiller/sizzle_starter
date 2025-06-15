import 'package:settings_domain/settings_domain.dart';
import 'package:settings_impl/src/datasources/settings_local_datasource.dart';
import 'package:settings_impl/src/repositories/settings_repository_impl.dart';
import 'package:shared_preferences/shared_preferences.dart';

SettingsRepository createSettingsRepository(SharedPreferencesAsync sharedPreferences) {
  return SettingsRepositoryImpl(
    settingsLocalDatasource: SettingsLocalDatasourceSharedPreferences(
      sharedPreferences: sharedPreferences,
    ),
  );
}
