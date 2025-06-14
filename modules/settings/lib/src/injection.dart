import 'package:settings/src/data/datasources/settings_local_datasource.dart';
import 'package:settings/src/data/repositories/settings_repository_impl.dart';
import 'package:settings/src/presentation/bloc/settings_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsContainer {
  const SettingsContainer._({required this.settingsBloc});

  final SettingsBloc settingsBloc;

  static Future<SettingsContainer> create(SharedPreferencesAsync preferences) async {
    final settingsRepository = SettingsRepositoryImpl(
      settingsLocalDatasource: SettingsLocalDatasourceSharedPreferences(
        sharedPreferences: preferences,
      ),
    );

    final settings = await settingsRepository.readSettings();

    final settingsBloc = SettingsBloc(
      initialState: SettingsStateIdle(settings: settings),
      settingsRepository: settingsRepository,
    );

    return SettingsContainer._(settingsBloc: settingsBloc);
  }
}
