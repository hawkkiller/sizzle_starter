import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizzle_starter/src/core/constant/config.dart';
import 'package:sizzle_starter/src/core/utils/app_bloc_observer.dart';
import 'package:sizzle_starter/src/core/utils/bloc_transformer.dart';
import 'package:sizzle_starter/src/core/utils/logger/logger.dart';
import 'package:sizzle_starter/src/core/utils/logger/logging_observer.dart';
import 'package:sizzle_starter/src/feature/initialization/logic/composition_root.dart';
import 'package:sizzle_starter/src/feature/initialization/widget/app.dart';
import 'package:sizzle_starter/src/feature/initialization/widget/initialization_failed_app.dart';

Future<void> main() async {
  const config = Config();
  final errorTrackingManager = await const ErrorTrackingManagerFactory(config).create();
  final logger = AppLoggerFactory(
    observers: [
      errorTrackingManager,
      if (!kReleaseMode) const LoggingObserver(logLevel: LogLevel.trace),
    ],
  ).create();

  await runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      // Override logging
      FlutterError.onError = logger.logFlutterError;
      WidgetsBinding.instance.platformDispatcher.onError = logger.logPlatformDispatcherError;

      // Setup bloc observer and transformer
      Bloc.observer = AppBlocObserver(logger);
      Bloc.transformer = SequentialBlocTransformer().transform;

      Future<void> startApp() async {
        try {
          final compositionResult = await CompositionRoot(
            config: config,
            logger: logger,
            errorTrackingManager: errorTrackingManager,
          ).compose();
          // Attach this widget to the root of the tree.
          runApp(App(result: compositionResult));
        } on Object catch (e, stackTrace) {
          logger.error('Initialization failed', error: e, stackTrace: stackTrace);
          runApp(
            InitializationFailedApp(
              error: e,
              stackTrace: stackTrace,
              onRetryInitialization: startApp,
            ),
          );
        }
      }

      // Run the app
      await startApp();
    },
    logger.logZoneError,
  );
}
