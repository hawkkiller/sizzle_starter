import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'initialization_progress.freezed.dart';

@freezed
class ResultingRepositories with _$ResultingRepositories {
  const factory ResultingRepositories() = _ResultingRepositories;
}

@freezed
class ResultingDependencies with _$ResultingDependencies {
  const factory ResultingDependencies({
    required SharedPreferences preferences,
    required GoRouter router,
  }) = _ResultingDependencies;

  const ResultingDependencies._();
}

@freezed
class InitializationRepositories with _$InitializationRepositories {
  const factory InitializationRepositories() = _InitializationRepositories;

  ResultingRepositories result() => const ResultingRepositories();

  const InitializationRepositories._();
}

@freezed
class InitializationDependencies with _$InitializationDependencies {
  const factory InitializationDependencies({
    SharedPreferences? preferences,
    GoRouter? router,
  }) = _InitializationDependencies;

  ResultingDependencies result() => ResultingDependencies(
        preferences: preferences!,
        router: router!,
      );

  const InitializationDependencies._();
}

@freezed
class InitializationResult with _$InitializationResult {
  const factory InitializationResult({
    required ResultingDependencies dependencies,
    required ResultingRepositories repositories,
    required int stepCount,
    required int msSpent,
  }) = _InitializationResult;
}

@freezed
class InitializationWrapper with _$InitializationWrapper {
  const factory InitializationWrapper({
    required InitializationRepositories repositories,
    required InitializationDependencies dependencies,
  }) = _InitializationWrapper;

  const InitializationWrapper._();
}
