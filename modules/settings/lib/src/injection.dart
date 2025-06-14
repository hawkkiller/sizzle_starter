import 'package:flutter/material.dart';
import 'package:settings/src/data/datasources/settings_local_datasource.dart';
import 'package:settings/src/data/repositories/settings_repository_impl.dart';
import 'package:settings/src/presentation/bloc/settings_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsContainer {
  const SettingsContainer._({required this.settingsBloc});

  final SettingsBloc settingsBloc;

  /// Get the [SettingsContainer] instance from the context.
  static SettingsContainer of(BuildContext context) {
    final settingsInherited = context.getInheritedWidgetOfExactType<SettingsContainerInherited>();

    if (settingsInherited == null) {
      throw Exception('SettingsInherited not found in context');
    }

    return settingsInherited.settingsContainer;
  }

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

class SettingsContainerInherited extends InheritedWidget {
  const SettingsContainerInherited({required super.child, required this.settingsContainer});

  final SettingsContainer settingsContainer;

  @override
  bool updateShouldNotify(SettingsContainerInherited oldWidget) {
    return false;
  }
}
