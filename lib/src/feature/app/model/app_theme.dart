import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// {@template app_theme_type}
/// The type of theme to use.
/// {@endtemplate}
enum AppColorSchemeType {
  /// Light theme.
  light,

  /// Dark theme.
  dark,

  /// Custom theme.
  custom,

  /// System theme.
  system;

  /// Whether this is a system theme.
  bool get isSystem => switch (this) {
        AppColorSchemeType.system => true,
        _ => false,
      };

  @override
  String toString() => switch (this) {
        AppColorSchemeType.light => 'light',
        AppColorSchemeType.dark => 'dark',
        AppColorSchemeType.system => 'system',
        AppColorSchemeType.custom => 'custom',
      };

  /// Creates a [AppColorSchemeType] from a [String].
  static AppColorSchemeType fromString(String value) => switch (value) {
        'light' => AppColorSchemeType.light,
        'dark' => AppColorSchemeType.dark,
        'custom' => AppColorSchemeType.custom,
        'system' => AppColorSchemeType.system,
        _ => throw Exception('Unknown AppColorSchemeType: $value'),
      };
}

/// {@template app_theme}
/// An immutable class that just holds the [ColorScheme].
/// {@endtemplate}
@immutable
final class AppTheme with Diagnosticable {
  /// The [ColorScheme] for this theme.
  final ColorScheme? colorScheme;

  /// The type of theme to use.
  final AppColorSchemeType type;

  /// {@macro app_theme}
  const AppTheme.create({
    required this.type,
    this.colorScheme,
  });

  /// Creates a [AppTheme] from a [Color] seed.
  factory AppTheme.fromSeed(
    Color seed, [
    Brightness brightness = Brightness.light,
  ]) =>
      AppTheme.create(
        colorScheme: ColorScheme.fromSeed(
          seedColor: seed,
          brightness: brightness,
        ),
        type: AppColorSchemeType.custom,
      );

  /// Light theme.
  static final lightScheme = AppTheme.create(
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.pink),
    type: AppColorSchemeType.light,
  );

  /// Dark theme.
  static final darkScheme = AppTheme.create(
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.pink,
      brightness: Brightness.dark,
    ),
    type: AppColorSchemeType.dark,
  );

  /// System theme.
  static const systemScheme = AppTheme.create(
    type: AppColorSchemeType.system,
  );

  /// All the light [AppTheme]s.
  static final lightValues = [
    ...List.generate(
      Colors.primaries.length,
      (index) => AppTheme.fromSeed(
        Colors.primaries[index],
      ),
    ),
  ];

  /// All the dark [AppTheme]s.
  static final darkValues = [
    ...List.generate(
      Colors.primaries.length,
      (index) => AppTheme.fromSeed(
        Colors.primaries[index],
        Brightness.dark,
      ),
    ),
  ];

  @pragma('vm:prefer-inline')
  AppTheme _systemOr(AppTheme other) => type.isSystem ? other : this;

  /// Get the dark [ThemeData] for this [AppTheme].
  ThemeData get darkTheme {
    final schema = _systemOr(darkScheme).colorScheme;
    return ThemeData(
      colorScheme: schema,
      brightness: schema?.brightness,
    );
  }

  /// Get the light [ThemeData] for this [AppTheme].
  ThemeData get lightTheme {
    final schema = _systemOr(lightScheme).colorScheme;
    return ThemeData(
      colorScheme: schema,
      brightness: schema?.brightness,
    );
  }

  /// Copy this [AppTheme] with the given parameters.
  AppTheme copyWith({
    ColorScheme? colorScheme,
    AppColorSchemeType? type,
  }) =>
      AppTheme.create(
        colorScheme: colorScheme ?? this.colorScheme,
        type: type ?? this.type,
      );

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      DiagnosticsProperty<ColorScheme?>('colorScheme', colorScheme),
    );
    properties.add(EnumProperty<AppColorSchemeType>('type', type));
    properties.add(DiagnosticsProperty<ThemeData>('lightTheme', lightTheme));
    properties.add(DiagnosticsProperty<ThemeData>('darkTheme', darkTheme));
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppTheme &&
          runtimeType == other.runtimeType &&
          colorScheme == other.colorScheme &&
          type == other.type;

  @override
  int get hashCode => colorScheme.hashCode ^ type.hashCode;
}
