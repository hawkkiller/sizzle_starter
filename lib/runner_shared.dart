import 'dart:async';

import 'package:l/l.dart';
import 'package:sizzle_starter/src/core/utils/logger.dart';
import 'package:sizzle_starter/src/feature/app/logic/app_runner.dart';
import 'package:sizzle_starter/src/feature/initialization/logic/initialization_processor.dart';
import 'package:sizzle_starter/src/feature/initialization/model/dependencies.dart';
import 'package:sizzle_starter/src/feature/initialization/model/initialization_hook.dart';

void _onInitializing(InitializationStepInfo info) {
  final percentage = ((info.step / info.stepsCount) * 100).toInt();
  l.i(
    'Inited ${info.stepName} in ${info.msSpent} ms | '
    'Progress: $percentage%',
  );
}

void _onInitialized(InitializationResult result) {
  l.i('Initialization completed successfully in ${result.msSpent} ms');
}

void _onError(int step, Object error) {
  l.e('Initialization failed on step $step with error $error');
}

void _onInit() {
  l.i('Initialization started');
}

/// Run that uses all platforms
void sharedRun() {
  // there could be some shared initialization here
  final hook = InitializationHook.setup(
    onInitializing: _onInitializing,
    onInitialized: _onInitialized,
    onError: _onError,
    onInit: _onInit,
  );
  Logger.runLogging(() {
    runZonedGuarded(
      () => AppRunner().initializeAndRun(hook),
      Logger.logZoneError,
    );
  });
}
