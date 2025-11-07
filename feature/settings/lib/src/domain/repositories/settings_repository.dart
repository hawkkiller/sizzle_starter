import 'package:settings/settings.dart';

abstract interface class SettingsRepository {
  Future<void> save(Settings settings);
  Future<Settings> read();
}
