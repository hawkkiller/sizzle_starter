import 'dart:async';

import 'package:sizzle_starter/src/core/utils/logger.dart';
import 'package:sizzle_starter/src/feature/app/logic/app_runner.dart';

void main() {
  logger.runLogging(
    () => runZonedGuarded(
      () => const AppRunner().initializeAndRun(),
      logger.logZoneError,
    ),
    const LogOptions(),
  );
}
