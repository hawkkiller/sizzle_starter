import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizzle_starter/src/feature/app/data/locale_repository.dart';
import 'package:sizzle_starter/src/feature/app/data/theme_repository.dart';

/// {@template dependencies}
/// Dependencies container
/// {@endtemplate}
abstract base class Dependencies with Diagnosticable {
  /// {@macro dependencies}
  const Dependencies();

  /// Shared preferences
  abstract final SharedPreferences sharedPreferences;

  /// Theme repository
  abstract final ThemeRepository themeRepository;

  /// Locale repository
  abstract final LocaleRepository localeRepository;

  /// Freeze dependencies, so they cannot be modified
  Dependencies freeze();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      DiagnosticsProperty<SharedPreferences>(
        'sharedPreferences',
        sharedPreferences,
      ),
    );
    properties.add(
      DiagnosticsProperty<ThemeRepository>(
        'themeRepository',
        themeRepository,
      ),
    );
    properties.add(
      DiagnosticsProperty<LocaleRepository>(
        'localeRepository',
        localeRepository,
      ),
    );
  }
}

/// {@template mutable_dependencies}
/// Mutable version of dependencies
///
/// Used to build dependencies
/// {@endtemplate}
final class DependenciesMutable extends Dependencies {
  /// {@macro mutable_dependencies}
  DependenciesMutable();

  @override
  late SharedPreferences sharedPreferences;

  @override
  late ThemeRepository themeRepository;

  @override
  late LocaleRepository localeRepository;

  @override
  Dependencies freeze() => _DependenciesImmutable(
        sharedPreferences: sharedPreferences,
        themeRepository: themeRepository,
        localeRepository: localeRepository,
      );
}

/// {@template immutable_dependencies}
/// Immutable version of dependencies
///
/// Used to store dependencies
/// {@endtemplate}
final class _DependenciesImmutable extends Dependencies {
  /// {@macro immutable_dependencies}
  const _DependenciesImmutable({
    required this.sharedPreferences,
    required this.themeRepository,
    required this.localeRepository,
  });

  @override
  final SharedPreferences sharedPreferences;

  @override
  final ThemeRepository themeRepository;

  @override
  final LocaleRepository localeRepository;

  @override
  Dependencies freeze() => this;
}

/// {@template initialization_result}
/// Result of initialization
/// {@endtemplate}
final class InitializationResult {
  /// {@macro initialization_result}
  const InitializationResult({
    required this.dependencies,
    required this.stepCount,
    required this.msSpent,
  });

  /// The dependencies
  final Dependencies dependencies;

  /// The number of steps
  final int stepCount;

  /// The number of milliseconds spent
  final int msSpent;

  @override
  String toString() => 'InitializationResult('
      'dependencies: $dependencies, '
      'stepCount: $stepCount, '
      'msSpent: $msSpent'
      ')';
}
