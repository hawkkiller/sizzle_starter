import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// {@template app_theme_type}
/// The type of theme to use.
/// {@endtemplate}
enum AppThemeMode {
  /// Light theme.
  light,

  /// Dark theme.
  dark,

  /// System theme.
  system;

  /// Whether this is a system theme.
  bool get isSystem => switch (this) {
        AppThemeMode.system => true,
        _ => false,
      };

  @override
  String toString() => switch (this) {
        AppThemeMode.light => 'light',
        AppThemeMode.dark => 'dark',
        AppThemeMode.system => 'system',
      };

  /// Creates a [AppThemeMode] from a [String].
  static AppThemeMode fromString(String value) => switch (value) {
        'light' => AppThemeMode.light,
        'dark' => AppThemeMode.dark,
        'system' => AppThemeMode.system,
        _ => throw Exception('Unknown AppThemeMode: $value'),
      };
}

/// {@template app_theme}
/// An immutable class that holds properties needed
/// to build a [ThemeData] for the app.
/// {@endtemplate}
@immutable
final class AppTheme with Diagnosticable {
  /// The type of theme to use.
  final AppThemeMode type;

  /// The seed color to generate the [ColorScheme] from.
  final Color? seed;

  /// {@macro app_theme}
  const AppTheme({
    required this.type,
    this.seed,
  });

  /// Dark theme
  static const dark = AppTheme(type: AppThemeMode.dark);

  /// Light theme
  static const light = AppTheme(type: AppThemeMode.light);

  /// System theme
  static const system = AppTheme(type: AppThemeMode.system);

  /// All the light [AppTheme]s.
  static final lightValues = [
    ...List.generate(
      Colors.primaries.length,
      (index) => AppTheme(
        seed: Colors.primaries[index],
        type: AppThemeMode.light,
      ),
    ),
  ];

  /// All the dark [AppTheme]s.
  static final darkValues = [
    ...List.generate(
      Colors.primaries.length,
      (index) => AppTheme(
        seed: Colors.primaries[index],
        type: AppThemeMode.dark,
      ),
    ),
  ];

  /// Get the dark [ThemeData] for this [AppTheme].
  ThemeData get darkTheme {
    if (seed != null) {
      return ThemeData(
        colorSchemeSeed: seed,
        brightness: Brightness.dark,
        useMaterial3: true,
      );
    }

    // Define there your default dark theme.
    return ThemeData(
      brightness: Brightness.dark,
      useMaterial3: true,
      colorSchemeSeed: Colors.pink,
    );
  }

  /// Get the light [ThemeData] for this [AppTheme].
  ThemeData get lightTheme {
    if (seed != null) {
      return ThemeData(
        colorSchemeSeed: seed,
        brightness: Brightness.light,
        useMaterial3: true,
      );
    }

    // Define there your default light theme.
    return ThemeData(
      brightness: Brightness.light,
      useMaterial3: true,
      colorSchemeSeed: Colors.pink,
    );
  }

  /// Get the [ThemeMode] for this [AppTheme].
  ThemeMode get themeMode {
    if (type == AppThemeMode.system) {
      return ThemeMode.system;
    } else if (type == AppThemeMode.light) {
      return ThemeMode.light;
    } else {
      return ThemeMode.dark;
    }
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ColorProperty('seed', seed));
    properties.add(EnumProperty<AppThemeMode>('type', type));
    properties.add(DiagnosticsProperty<ThemeData>('lightTheme', lightTheme));
    properties.add(DiagnosticsProperty<ThemeData>('darkTheme', darkTheme));
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppTheme &&
          runtimeType == other.runtimeType &&
          seed == other.seed &&
          type == other.type;

  @override
  int get hashCode => type.hashCode ^ seed.hashCode;
}
