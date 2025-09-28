import 'package:settings_api/src/domain/model/settings.dart';

abstract interface class SettingsRepository {
  Settings get current;

  Stream<Settings> watch();

  Future<Settings> save(Settings Function(Settings settings) fn);
}
