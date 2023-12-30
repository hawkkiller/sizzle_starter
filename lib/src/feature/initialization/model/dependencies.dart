import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizzle_starter/src/feature/settings/bloc/settings_bloc.dart';
import 'package:sizzle_starter/src/feature/settings/data/settings_repository.dart';

/// {@template dependencies}
/// Dependencies container
/// {@endtemplate}
base class Dependencies {
  /// {@macro dependencies}
  Dependencies();

  /// [SharedPreferences] instance, used to store Key-Value pairs.
  late final SharedPreferences sharedPreferences;

  /// [SettingsRepository] instance, used to manage theme and locale.
  late final SettingsRepository settingsRepository;

  /// [SettingsBloc] instance, used to manage theme and locale.
  late final SettingsBloc settingsBloc;
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
  String toString() => '$InitializationResult('
      'dependencies: $dependencies, '
      'stepCount: $stepCount, '
      'msSpent: $msSpent'
      ')';
}
