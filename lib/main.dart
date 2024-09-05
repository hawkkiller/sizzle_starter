import 'dart:async';

import 'package:sizzle_starter/src/core/utils/refined_logger.dart';
import 'package:sizzle_starter/src/feature/initialization/logic/app_runner.dart';

void main() => runZonedGuarded(
      () => const AppRunner().initializeAndRun(),
      logger.logZoneError,
    );
