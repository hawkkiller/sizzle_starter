import 'dart:async';

import 'package:sizzle_starter/src/core/utils/logger.dart';
import 'package:sizzle_starter/src/feature/app/logic/app_runner.dart';
import 'package:sizzle_starter/src/feature/initialization/model/initialization_hook.dart';

/// Run that uses all platforms
void sharedRun(InitializationHook hook) {
  // there could be some shared initialization here
  Logger.runLogging(() {
    runZonedGuarded(
      () => AppRunner().initializeAndRun(hook),
      Logger.logZoneError,
    );
  });
}
