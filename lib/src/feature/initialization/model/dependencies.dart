import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizzle_starter/src/core/router/router.dart';

/// Dependencies container
abstract interface class Dependencies {
  /// Shared preferences
  abstract final SharedPreferences sharedPreferences;

  /// App router
  abstract final AppRouter router;

  /// Freeze dependencies, so they cannot be modified
  Dependencies freeze();
}

/// Mutable version of dependencies
///
/// Used to build dependencies
final class Dependencies$Mutable implements Dependencies {
  Dependencies$Mutable();

  @override
  late SharedPreferences sharedPreferences;

  @override
  late AppRouter router;

  @override
  Dependencies freeze() => _Dependencies$Immutable(
        sharedPreferences: sharedPreferences,
        router: router,
      );
}

/// Immutable version of dependencies
///
/// Used to store dependencies
final class _Dependencies$Immutable implements Dependencies {
  const _Dependencies$Immutable({
    required this.sharedPreferences,
    required this.router,
  });

  @override
  final SharedPreferences sharedPreferences;

  @override
  final AppRouter router;

  @override
  Dependencies freeze() => this;
}

final class InitializationResult {
  const InitializationResult({
    required this.dependencies,
    required this.stepCount,
    required this.msSpent,
  });

  final Dependencies dependencies;
  final int stepCount;
  final int msSpent;
}
