import 'dart:async';

import 'package:settings/settings.dart';
import 'package:settings/src/data/datasources/settings_local_datasource.dart';

final class SettingsRepositoryImpl implements SettingsRepository {
  const SettingsRepositoryImpl({required this.localDatasource});

  final SettingsLocalDatasource localDatasource;

  @override
  Future<void> save(Settings settings) async {
    await localDatasource.save(settings);
  }

  @override
  Future<Settings> read() async {
    return await localDatasource.read();
  }
}
