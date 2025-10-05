import 'dart:async';

import 'package:common/common.dart';
import 'package:settings/settings.dart';
import 'package:settings/src/data/datasources/settings_local_datasource.dart';

final class SettingsRepositoryImpl implements SettingsRepository {
  SettingsRepositoryImpl({
    required this.localDatasource,
    required this.current,
  });

  final _controller = StreamController<Settings>.broadcast();

  static Future<SettingsRepositoryImpl> init(SettingsLocalDatasource localDatasource) async {
    final currentSettings = await localDatasource.read();

    return SettingsRepositoryImpl(
      localDatasource: localDatasource,
      current: currentSettings,
    );
  }

  final SettingsLocalDatasource localDatasource;
  final _mutex = Mutext();

  @override
  Future<Settings> save(Settings Function(Settings settings) fn) => _mutex.runLocked(() async {
    final newSettings = fn(current);

    await localDatasource.save(newSettings);
    current = newSettings;
    _controller.add(current);

    return current;
  });

  @override
  Stream<Settings> watch() => _controller.stream;

  @override
  Settings current;
}
