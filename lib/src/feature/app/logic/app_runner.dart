import 'package:blaze_starter/src/core/model/initialization_hook.dart';
import 'package:blaze_starter/src/core/widget/app.dart';
import 'package:blaze_starter/src/feature/initialization/logic/initialization_processor.dart';
import 'package:blaze_starter/src/feature/initialization/logic/initialization_steps.dart';
import 'package:flutter/material.dart';

abstract class AppRunner {
  factory AppRunner() => _AppRunner();

  Future<void> initializeAndRun(InitializationHook hook);
}

class _AppRunner
    with InitializationSteps, InitializationProcessor, InitializationFactoryImpl
    implements AppRunner {
  @override
  Future<void> initializeAndRun(InitializationHook hook) async {
    final bindings = WidgetsFlutterBinding.ensureInitialized()
      ..deferFirstFrame();
    final result = await processInitialization(
      steps: steps,
      hook: hook,
      factory: this,
    );
    // Run application
    App(result: result).run();
    bindings.addPostFrameCallback((_) {
      bindings.allowFirstFrame();
    });
  }
}
