import 'package:blaze_starter/src/core/model/initialization_hook.dart';
import 'package:blaze_starter/src/feature/initialization/logic/initialization_steps.dart';
import 'package:blaze_starter/src/feature/initialization/model/initialization_progress.dart';

mixin InitializationProcessor {
  Future<InitializationResult> process({
    required Map<StepDescription, StepAction> steps,
    required InitializationHook hook,
  }) async {
    final stopwatch = Stopwatch()..start();
    var stepCount = 0;
    var wrapper = const InitializationWrapper(
      dependencies: InitializationDependencies(),
      repositories: InitializationRepositories(),
    );
    try {
      await for (final step in Stream.fromIterable(steps.entries)) {
        stepCount++;
        final w = await step.value(
          wrapper,
          wrapper.dependencies,
          wrapper.repositories,
        );
        wrapper = w;
        hook.onInitializing?.call(w);
      }
    } on Object catch (_) {
      hook.onError?.call(stepCount);
      rethrow;
    }
    stopwatch.stop();
    final result = InitializationResult(
      repositories: wrapper.repositories.result(),
      dependencies: wrapper.dependencies.result(),
      stepCount: stepCount,
      msSpent: stopwatch.elapsedMilliseconds,
    );
    hook.onInitialized?.call(result);
    return result;
  }
}
