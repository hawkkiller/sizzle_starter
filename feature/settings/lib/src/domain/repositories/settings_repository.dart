import 'package:settings/settings.dart';

abstract interface class SettingsRepository {
  Settings get current;

  Stream<Settings> watch();

  Future<Settings> save(Settings Function(Settings settings) fn);
}
