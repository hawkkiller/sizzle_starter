import 'dart:async';

import 'package:sizzle_starter/src/feature/settings/data/datasources/settings_local_datasource.dart';
import 'package:sizzle_starter/src/feature/settings/domain/model/settings.dart';
import 'package:sizzle_starter/src/feature/settings/domain/repositories/settings_repository.dart';

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
