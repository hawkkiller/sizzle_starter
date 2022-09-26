import 'package:blaze_starter/src/core/model/environment_store.dart';
import 'package:blaze_starter/src/core/model/initialization_hook.dart';
import 'package:blaze_starter/src/feature/app/logic/tracking_manager.dart';
import 'package:blaze_starter/src/feature/initialization/logic/initialization_steps.dart';
import 'package:blaze_starter/src/feature/initialization/model/initialization_progress.dart';
import 'package:flutter/foundation.dart';

part 'initialization_factory.dart';

mixin InitializationProcessor {
  Future<InitializationResult> process({
    required Map<StepDescription, StepAction> steps,
    required InitializationFactory factory,
    required InitializationHook hook,
  }) async {
    final stopwatch = Stopwatch()..start();
    var stepCount = 0;
    var progress = const InitializationProgress();
    final env = factory.getEnvironmentStore();
    final trackingManager = factory.createTrackingManager(env);
    await trackingManager.enableReporting(shouldSend: !kDebugMode);
    try {
      await for (final step in Stream.fromIterable(steps.entries)) {
        stepCount++;
        final p = await step.value(progress);
        if (p != null) {
          progress = p;
          hook.onInitializing?.call(p);
        }
      }
    } on Object catch (_) {
      hook.onError?.call(stepCount);
      rethrow;
    }
    stopwatch.stop();
    final result = InitializationResult(
      dependencies: progress.dependencies(),
      repositories: progress.repositories(),
      stepCount: stepCount,
      msSpent: stopwatch.elapsedMilliseconds,
    );
    hook.onInitialized?.call(result);
    return result;
  }
}
