import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizzle_starter/src/core/router/router.dart';

part 'initialization_progress.freezed.dart';

class RepositoriesStore {
  const RepositoriesStore();
}

class DependenciesStore {
  const DependenciesStore({
    required this.sharedPreferences,
    required this.router,
  });

  final SharedPreferences sharedPreferences;
  final AppRouter router;
}

class InitializationProgress {
  InitializationProgress();

  SharedPreferences? sharedPreferences;
  AppRouter? router;

  DependenciesStore dependencies() => DependenciesStore(
        sharedPreferences: sharedPreferences!,
        router: router!,
      );

  RepositoriesStore repositories() => const RepositoriesStore();
}

@freezed
class InitializationResult with _$InitializationResult {
  const factory InitializationResult({
    required DependenciesStore dependencies,
    required RepositoriesStore repositories,
    required int stepCount,
    required int msSpent,
  }) = _InitializationResult;
}
