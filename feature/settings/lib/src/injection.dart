import 'package:settings/settings.dart';
import 'package:settings/src/data/datasources/settings_local_datasource.dart';
import 'package:settings/src/data/repositories/settings_repository_impl.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<SettingsRepository> _createSettingsRepository(SharedPreferencesAsync sharedPreferences) {
  return SettingsRepositoryImpl.init(
    SettingsLocalDatasourceSharedPreferences(sharedPreferences: sharedPreferences),
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
    final settingsRepository = await _createSettingsRepository(sharedPreferences);

    return SettingsContainer(
      settingsRepository: settingsRepository,
      settingsBloc: SettingsBloc(settingsRepository: settingsRepository),
    );
  }
}
