import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizzle_starter/src/core/router/router.dart';

part 'initialization_progress.freezed.dart';

@freezed
class RepositoriesStore with _$RepositoriesStore {
  const factory RepositoriesStore() = _RepositoriesStore;
}

@freezed
class DependenciesStore with _$DependenciesStore {
  const factory DependenciesStore({
    required SharedPreferences preferences,
    required AppRouter router,
  }) = _DependenciesStore;

  const DependenciesStore._();
}

@freezed
class InitializationProgress with _$InitializationProgress {
  const factory InitializationProgress({
    SharedPreferences? preferences,
    AppRouter? router,
  }) = _InitializationProgress;

  const InitializationProgress._();

  DependenciesStore dependencies() => DependenciesStore(
        preferences: preferences!,
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
