import 'package:sizzle_starter/src/feature/initialization/model/dependencies.dart';
import 'package:sizzle_starter/src/feature/initialization/model/environment_store.dart';

/// Initialization progress
/// @{nodoc}
final class InitializationProgress {
  const InitializationProgress({
    required this.dependencies,
    required this.environmentStore,
  });

  /// Mutable version of dependencies
  final Dependencies$Mutable dependencies;

  /// Environment store
  final IEnvironmentStore environmentStore;

  /// Freeze dependencies, so they cannot be modified
  Dependencies freeze() => dependencies.freeze();
}
