import 'package:settings_api/settings_api.dart';
import 'package:settings_api/src/data/datasources/settings_local_datasource.dart';
import 'package:settings_api/src/data/repositories/settings_repository_impl.dart';
import 'package:shared_preferences/shared_preferences.dart';

SettingsRepository _createSettingsRepository(SharedPreferencesAsync sharedPreferences) {
  return SettingsRepositoryImpl(
    settingsLocalDatasource: SettingsLocalDatasourceSharedPreferences(
      sharedPreferences: sharedPreferences,
    ),
  );
}

Future<SettingsBloc> _createSettingsBloc(SettingsRepository settingsRepository) async {
  final settings = await settingsRepository.read();
  final initialState = SettingsState.idle(settings: settings);

  return SettingsBloc(
    initialState: initialState,
    settingsRepository: settingsRepository,
  );
}

/// Container with global settings state.
class SettingsContainer {
  const SettingsContainer({
    required this.settingsRepository,
    required this.settingsBloc,
  });

  final SettingsRepository settingsRepository;
  final SettingsBloc settingsBloc;

  static Future<SettingsContainer> create(SharedPreferencesAsync sharedPreferences) async {
    final settingsRepository = _createSettingsRepository(sharedPreferences);
    final settingsBloc = await _createSettingsBloc(settingsRepository);

    return SettingsContainer(
      settingsRepository: settingsRepository,
      settingsBloc: settingsBloc,
    );
  }
}
