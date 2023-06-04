import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizzle_starter/src/core/router/router.dart';

final class RepositoriesStore {
  const RepositoriesStore();
}

final class DependenciesStore {
  const DependenciesStore({
    required this.sharedPreferences,
    required this.router,
  });

  final SharedPreferences sharedPreferences;
  final AppRouter router;
}

final class InitializationProgress {
  InitializationProgress();

  SharedPreferences? sharedPreferences;
  AppRouter? router;

  DependenciesStore dependencies() => DependenciesStore(
        sharedPreferences: sharedPreferences!,
        router: router!,
      );

  RepositoriesStore repositories() => const RepositoriesStore();
}

final class InitializationResult {
  const InitializationResult({
    required this.dependencies,
    required this.repositories,
    required this.stepCount,
    required this.msSpent,
  });

  final DependenciesStore dependencies;
  final RepositoriesStore repositories;
  final int stepCount;
  final int msSpent;
}
