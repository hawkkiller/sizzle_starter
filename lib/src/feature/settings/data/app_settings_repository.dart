import 'package:sizzle_starter/src/feature/settings/data/app_settings_datasource.dart';
import 'package:sizzle_starter/src/feature/settings/model/app_settings.dart';

/// {@template app_settings_repository}
/// [AppSettingsRepository] sets and gets app settings.
/// {@endtemplate}
abstract interface class AppSettingsRepository {
  /// Set app settings
  Future<void> setAppSettings(AppSettings appSettings);

  /// Load [AppSettings] from the source of truth.
  Future<AppSettings?> getAppSettings();
}

/// {@macro app_settings_repository}
final class AppSettingsRepositoryImpl implements AppSettingsRepository {
  /// {@macro app_settings_repository}
  const AppSettingsRepositoryImpl({required this.datasource});

  /// The instance of [AppSettingsDatasource] used to read and write values.
  final AppSettingsDatasource datasource;

  @override
  Future<AppSettings?> getAppSettings() => datasource.getAppSettings();

  @override
  Future<void> setAppSettings(AppSettings appSettings) => datasource.setAppSettings(appSettings);
}
