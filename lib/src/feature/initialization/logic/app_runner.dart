import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizzle_starter/src/core/constant/application_config.dart';
import 'package:sizzle_starter/src/core/utils/app_bloc_observer.dart';
import 'package:sizzle_starter/src/core/utils/bloc_transformer.dart';
import 'package:sizzle_starter/src/core/utils/error_tracking_manager/error_tracking_manager.dart';
import 'package:sizzle_starter/src/core/utils/logger/logger.dart';
import 'package:sizzle_starter/src/core/utils/logger/logging_observer.dart';
import 'package:sizzle_starter/src/feature/initialization/logic/composition_root.dart';
import 'package:sizzle_starter/src/feature/initialization/widget/initialization_failed_app.dart';
import 'package:sizzle_starter/src/feature/initialization/widget/root_context.dart';

/// {@template app_runner}
/// A class that is responsible for running the application.
/// {@endtemplate}
class AppRunner {
  /// {@macro app_runner}
  const AppRunner._({
    required this.config,
    required this.logger,
    required this.errorTrackingManager,
  });

  /// Application configuration
  final ApplicationConfig config;

  /// Application-wide logger
  final Logger logger;

  /// Error tracking manager
  final ErrorTrackingManager errorTrackingManager;

  /// Creates a new [AppRunner] instance with error tracking and logging set up.
  static Future<AppRunner> create() async {
    const config = ApplicationConfig();
    final errorTrackingManager = await const ErrorTrackingManagerFactory(config).create();

    final logger = AppLoggerFactory(
      observers: [
        errorTrackingManager,
        if (!kReleaseMode) const LoggingObserver(logLevel: LogLevel.trace),
      ],
    ).create();

    return AppRunner._(
      config: config,
      logger: logger,
      errorTrackingManager: errorTrackingManager,
    );
  }

  /// Initializes dependencies and launches the application within a guarded execution zone.
  Future<void>? startup() => runZonedGuarded(
        () async {
          // Ensure Flutter is initialized
          WidgetsFlutterBinding.ensureInitialized();

          // Configure global error interception
          FlutterError.onError = logger.logFlutterError;
          WidgetsBinding.instance.platformDispatcher.onError = logger.logPlatformDispatcherError;

          // Setup bloc observer and transformer
          Bloc.observer = AppBlocObserver(logger);
          Bloc.transformer = SequentialBlocTransformer().transform;

          Future<void> launchApplication() async {
            try {
              final compositionResult = await CompositionRoot(
                config: config,
                logger: logger,
                errorTrackingManager: errorTrackingManager,
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

          // Run the app
          await launchApplication();
        },
        logger.logZoneError,
      );
}
