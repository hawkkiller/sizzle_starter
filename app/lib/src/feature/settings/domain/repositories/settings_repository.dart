import 'package:sizzle_starter/src/feature/settings/domain/model/settings.dart';

abstract interface class SettingsRepository {
  Future<void> save(Settings settings);
  Future<Settings> read();
}
