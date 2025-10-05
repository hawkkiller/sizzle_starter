import 'package:settings/src/domain/model/general_configuration.dart';
import 'package:settings/src/domain/model/theme_configuration.dart';

/// Settings for the app.
class Settings {
  const Settings({
    this.theme = const ThemeConfiguration(),
    this.general = const GeneralConfiguration(),
  });

  final ThemeConfiguration theme;
  final GeneralConfiguration general;

  Settings copyWith({
    ThemeConfiguration? theme,
    GeneralConfiguration? general,
  }) => Settings(
    theme: theme ?? this.theme,
    general: general ?? this.general,
  );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Settings && other.theme == theme && other.general == general;
  }

  @override
  int get hashCode => Object.hash(theme, general);
}
