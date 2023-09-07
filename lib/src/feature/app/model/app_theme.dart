import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// {@template app_theme}
/// An immutable class that holds properties needed
/// to build a [ThemeData] for the app.
/// {@endtemplate}
@immutable
final class AppTheme with Diagnosticable {
  /// The type of theme to use.
  final ThemeMode mode;

  /// The seed color to generate the [ColorScheme] from.
  final Color? seed;

  /// {@macro app_theme}
  AppTheme({
    required this.mode,
    this.seed,
  })  : darkTheme = ThemeData(
          colorSchemeSeed: seed ?? Colors.pink,
          brightness: Brightness.dark,
          useMaterial3: true,
        ),
        lightTheme = ThemeData(
          colorSchemeSeed: seed ?? Colors.pink,
          brightness: Brightness.light,
          useMaterial3: true,
        );

  /// Light mode [AppTheme].
  static final light = AppTheme(mode: ThemeMode.light);

  /// Dark mode [AppTheme].
  static final dark = AppTheme(mode: ThemeMode.dark);

  /// System mode [AppTheme].
  static final system = AppTheme(mode: ThemeMode.system);

  /// All the light [AppTheme]s.
  static final values = [
    ...List.generate(
      Colors.primaries.length,
      (index) => AppTheme(
        seed: Colors.primaries[index],
        mode: ThemeMode.system,
      ),
    ),
  ];

  /// The dark [ThemeData] for this [AppTheme].
  final ThemeData darkTheme;

  /// The light [ThemeData] for this [AppTheme].
  final ThemeData lightTheme;

  /// The [ThemeData] for this [AppTheme].
  /// This is computed based on the [mode].
  ///
  /// Could be useful for theme showcase.
  ThemeData computeTheme(BuildContext context) {
    switch (mode) {
      case ThemeMode.light:
        return lightTheme;
      case ThemeMode.dark:
        return darkTheme;
      case ThemeMode.system:
        return MediaQuery.platformBrightnessOf(context) == Brightness.dark
            ? darkTheme
            : lightTheme;
    }
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ColorProperty('seed', seed));
    properties.add(EnumProperty<ThemeMode>('type', mode));
    properties.add(DiagnosticsProperty<ThemeData>('lightTheme', lightTheme));
    properties.add(DiagnosticsProperty<ThemeData>('darkTheme', darkTheme));
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppTheme &&
          runtimeType == other.runtimeType &&
          seed == other.seed &&
          mode == other.mode;

  @override
  int get hashCode => mode.hashCode ^ seed.hashCode;
}
