import 'package:settings_api/settings_api.dart';
import 'package:settings_api/src/data/datasources/settings_local_datasource.dart';
import 'package:settings_api/src/data/repositories/settings_repository_impl.dart';
import 'package:shared_preferences/shared_preferences.dart';

SettingsRepository createSettingsRepository(SharedPreferencesAsync sharedPreferences) {
  return SettingsRepositoryImpl(
    settingsLocalDatasource: SettingsLocalDatasourceSharedPreferences(
      sharedPreferences: sharedPreferences,
    ),
  );
}

Future<SettingsBloc> createSettingsBloc(SettingsRepository settingsRepository) async {
  final settings = await settingsRepository.read();
  final initialState = SettingsState.idle(settings: settings);

  return SettingsBloc(
    initialState: initialState,
    settingsRepository: settingsRepository,
  );
}
