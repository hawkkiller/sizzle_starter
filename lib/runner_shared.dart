import 'package:blaze_starter/src/core/model/initialization_hook.dart';
import 'package:blaze_starter/src/feature/app/login/app_runner.dart';

void sharedRun(InitializationHook hook) {
  // there could be some shared initialization here
  AppRunner.initializeAndRun(hook);
}
