import 'package:settings_api/src/domain/model/settings.dart';

abstract interface class SettingsRepository {
  Stream<Settings?> watch();
  Future<void> save(Settings settings);
  Future<Settings?> read();
}
