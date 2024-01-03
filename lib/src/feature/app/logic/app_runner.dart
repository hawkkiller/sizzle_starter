import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart' as bloc_concurrency;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:sizzle_starter/src/core/utils/app_bloc_observer.dart';
import 'package:sizzle_starter/src/core/utils/logger.dart';
import 'package:sizzle_starter/src/feature/app/widget/app.dart';
import 'package:sizzle_starter/src/feature/initialization/logic/initialization_processor.dart';

/// {@template app_runner}
/// A class which is responsible for initialization and running the app.
/// {@endtemplate}
final class AppRunner with InitializationFactoryImpl {
  /// {@macro app_runner}
  const AppRunner();

  /// Start the initialization and in case of success run application
  Future<void> initializeAndRun() async {
    final binding = WidgetsFlutterBinding.ensureInitialized();

    // Preserve splash screen
    FlutterNativeSplash.preserve(widgetsBinding: binding);

    // Override logging
    FlutterError.onError = logger.logFlutterError;
    WidgetsBinding.instance.platformDispatcher.onError =
        logger.logPlatformDispatcherError;

    // Setup bloc observer and transformer
    Bloc.observer = const AppBlocObserver();
    Bloc.transformer = bloc_concurrency.sequential();

    final environmentStore = getEnvironmentStore();

    final initializationProcessor = InitializationProcessor(
      trackingManager: createTrackingManager(environmentStore),
      environmentStore: environmentStore,
    );

    final result = await initializationProcessor.initialize();

    // Allow rendering
    FlutterNativeSplash.remove();

    // Attach this widget to the root of the tree.
    runApp(App(result: result));
  }
}
