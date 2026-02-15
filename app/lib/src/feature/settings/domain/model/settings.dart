import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sizzle_starter/src/feature/settings/domain/model/general.dart';

part 'settings.freezed.dart';
part 'settings.g.dart';

/// Settings for the app.
@freezed
abstract class Settings with _$Settings {
  const factory Settings({@Default(GeneralSettings()) GeneralSettings general}) = _Settings;

  factory Settings.fromJson(Map<String, Object?> json) => _$SettingsFromJson(json);
}
