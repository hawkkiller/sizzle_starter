import 'package:sizzle_starter/src/feature/settings/domain/model/general.dart';

/// Settings for the app.
class Settings {
  const Settings({this.general = const GeneralSettings()});

  final GeneralSettings general;

  Settings copyWith({GeneralSettings? general}) => Settings(
    general: general ?? this.general,
  );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Settings && other.general == general;
  }

  @override
  int get hashCode => general.hashCode;
}
