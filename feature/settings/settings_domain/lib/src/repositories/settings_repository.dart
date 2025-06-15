import 'package:settings_domain/src/model/settings.dart';

abstract interface class SettingsRepository {
  Stream<Settings?> watch();
  Future<void> save(Settings settings);
  Future<Settings?> read();
}
