import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:sizzle_starter/src/core/common/bloc/app_bloc_observer.dart';
import 'package:sizzle_starter/src/core/common/bloc/bloc_transformer.dart';
import 'package:sizzle_starter/src/core/common/error_reporter/error_reporter.dart';
import 'package:sizzle_starter/src/core/constant/application_config.dart';
import 'package:sizzle_starter/src/feature/initialization/logic/composition_root.dart';
import 'package:sizzle_starter/src/feature/initialization/widget/initialization_failed_app.dart';
import 'package:sizzle_starter/src/feature/initialization/widget/root_context.dart';

/// {@template app_runner}
/// A class that is responsible for running the application.
/// {@endtemplate}
sealed class AppRunner {
  /// {@macro app_runner}
  const AppRunner._();

  /// Initializes dependencies and launches the application within a guarded execution zone.
  static Future<void> startup() async {
    const config = ApplicationConfig();
    final errorReporter = await createErrorReporter(config);

    final logger = createAppLogger(
      observers: [
        ErrorReporterLogObserver(errorReporter),
        if (!kReleaseMode) const PrintingLogObserver(logLevel: LogLevel.trace),
      ],
    );

    await runZonedGuarded(() async {
      // Ensure Flutter is initialized
      WidgetsFlutterBinding.ensureInitialized();

      // Configure global error interception
      FlutterError.onError = logger.logFlutterError;
      WidgetsBinding.instance.platformDispatcher.onError = logger.logPlatformDispatcherError;

      // Setup bloc observer and transformer
      Bloc.observer = AppBlocObserver(logger);
      Bloc.transformer = SequentialBlocTransformer<Object?>().transform;

      Future<void> launchApplication() async {
        try {
          final compositionResult =
              await CompositionRoot(
                config: config,
                logger: logger,
                errorReporter: errorReporter,
              ).compose();

          runApp(RootContext(compositionResult: compositionResult));
        } on Object catch (e, stackTrace) {
          logger.error('Initialization failed', error: e, stackTrace: stackTrace);
          runApp(
            InitializationFailedApp(
              error: e,
              stackTrace: stackTrace,
              onRetryInitialization: launchApplication,
            ),
          );
        }
      }

      // Launch the application
      await launchApplication();
    }, logger.logZoneError);
  }
}
