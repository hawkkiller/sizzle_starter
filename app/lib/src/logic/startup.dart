import 'dart:async';

import 'package:error_reporter/error_reporter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:sizzle_starter/src/bloc/app_bloc_observer.dart';
import 'package:sizzle_starter/src/bloc/bloc_transformer.dart';
import 'package:sizzle_starter/src/logic/composition_root.dart';
import 'package:sizzle_starter/src/model/application_config.dart';
import 'package:sizzle_starter/src/widget/initialization_failed_app.dart';
import 'package:sizzle_starter/src/widget/root_context.dart';

/// Initializes dependencies and runs app
Future<void> startup() async {
  const config = ApplicationConfig();
  final errorReporter = await createErrorReporter(config);

  final logger = createAppLogger(
    observers: [
      ErrorReporterLogObserver(errorReporter),
      if (!kReleaseMode) const PrintingLogObserver(logLevel: LogLevel.trace),
    ],
  );

  await runZonedGuarded(
    () async {
      // Ensure Flutter is initialized
      WidgetsFlutterBinding.ensureInitialized();

      // Configure global error interception
      FlutterError.onError = logger.logFlutterError;
      WidgetsBinding.instance.platformDispatcher.onError = logger.logPlatformDispatcherError;

      // Setup bloc observer and transformer
      Bloc.observer = AppBlocObserver(logger);
      Bloc.transformer = SequentialBlocTransformer<Object?>().transform;

      Future<void> composeAndRun() async {
        try {
          final compositionResult = await composeDependencies(
            config: config,
            logger: logger,
            errorReporter: errorReporter,
          );

          runApp(RootContext(compositionResult: compositionResult));
        } on Object catch (e, stackTrace) {
          logger.error('Initialization failed', error: e, stackTrace: stackTrace);
          runApp(
            InitializationFailedApp(
              error: e,
              stackTrace: stackTrace,
              onRetryInitialization: composeAndRun,
            ),
          );
        }
      }

      // Launch the application
      await composeAndRun();
    },
    logger.logZoneError,
  );
}
