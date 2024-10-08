import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart' as bloc_concurrency;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizzle_starter/src/core/constant/config.dart';
import 'package:sizzle_starter/src/core/utils/app_bloc_observer.dart';
import 'package:sizzle_starter/src/core/utils/refined_logger.dart';
import 'package:sizzle_starter/src/feature/initialization/logic/composition_root.dart';
import 'package:sizzle_starter/src/feature/initialization/widget/app.dart';
import 'package:sizzle_starter/src/feature/initialization/widget/initialization_failed_app.dart';

/// {@template app_runner}
/// A class which is responsible for initialization and running the app.
/// {@endtemplate}
final class AppRunner {
  /// {@macro app_runner}
  const AppRunner();

  /// Start the initialization and in case of success run application
  Future<void> initializeAndRun() async {
    final binding = WidgetsFlutterBinding.ensureInitialized();

    // Preserve splash screen
    binding.deferFirstFrame();

    // Override logging
    FlutterError.onError = logger.logFlutterError;
    WidgetsBinding.instance.platformDispatcher.onError = logger.logPlatformDispatcherError;

    // Setup bloc observer and transformer
    Bloc.observer = AppBlocObserver(logger);
    Bloc.transformer = bloc_concurrency.sequential();
    const config = Config();

    Future<void> initializeAndRun() async {
      try {
        final result = await CompositionRoot(config, logger).compose();
        // Attach this widget to the root of the tree.
        runApp(App(result: result));
      } catch (e, stackTrace) {
        logger.error('Initialization failed', error: e, stackTrace: stackTrace);
        runApp(
          InitializationFailedApp(
            error: e,
            stackTrace: stackTrace,
            onRetryInitialization: initializeAndRun,
          ),
        );
      } finally {
        // Allow rendering
        binding.allowFirstFrame();
      }
    }

    // Run the app
    await initializeAndRun();
  }
}
