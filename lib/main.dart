import 'dart:async';

import 'package:sizzle_starter/src/core/utils/logger.dart';
import 'package:sizzle_starter/src/feature/initialization/logic/app_runner.dart';

void main() {
  final logger = DeveloperLogger();

  runZonedGuarded(
    () => AppRunner(logger).initializeAndRun(),
    logger.logZoneError,
  );
}
