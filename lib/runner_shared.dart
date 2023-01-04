import 'dart:async';

import 'package:blaze_starter/src/core/logic/logger.dart';
import 'package:blaze_starter/src/core/model/initialization_hook.dart';
import 'package:blaze_starter/src/feature/app/logic/app_runner.dart' as blaze;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void sharedRun(InitializationHook hook) {
  FlutterError.onError = Logger.logFlutterError;
  // there could be some shared initialization here
  Logger.runLogging(() {
    runZonedGuarded(
      () async {
        await blaze.AppRunner().initializeAndRun(hook);
      },
      Logger.logZoneError,
    );
  });
}
