import 'package:blaze_starter/src/core/model/initialization_hook.dart';
import 'package:blaze_starter/src/core/widget/app.dart';
import 'package:blaze_starter/src/feature/initialization/logic/initialization_steps.dart';
import 'package:blaze_starter/src/feature/initialization/logic/intialization_processor.dart';
import 'package:flutter/material.dart';

abstract class AppRunner {
  factory AppRunner() => _AppRunner();

  Future<void> initializeAndRun(InitializationHook hook);
}

class _AppRunner
    with InitializationSteps, InitializationProcessor
    implements AppRunner {
  @override
  Future<void> initializeAndRun(InitializationHook hook) async {
    final bindings = WidgetsFlutterBinding.ensureInitialized()
      ..deferFirstFrame();
    final result = await process(
      steps: steps,
      hook: hook,
    );
    // Run application
    App(result: result).run();
    bindings.addPostFrameCallback((_) {
      bindings.allowFirstFrame();
    });
  }
}
