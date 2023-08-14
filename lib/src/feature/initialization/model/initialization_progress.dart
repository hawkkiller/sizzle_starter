import 'package:sizzle_starter/src/feature/initialization/model/dependencies.dart';
import 'package:sizzle_starter/src/feature/initialization/model/environment_store.dart';

/// {@template initialization_progress}
/// A class which represents the initialization progress.
/// {@endtemplate}
final class InitializationProgress {
  /// {@macro initialization_progress}
  const InitializationProgress({
    required this.dependencies,
    required this.environmentStore,
  });

  /// Mutable version of dependencies
  final DependenciesMutable dependencies;

  /// Environment store
  final IEnvironmentStore environmentStore;

  /// Freeze dependencies, so they cannot be modified
  Dependencies freeze() => dependencies.freeze();
}
