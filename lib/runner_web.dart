import 'package:blaze_starter/runner_shared.dart';
import 'package:blaze_starter/src/core/model/initialization_hook.dart';

// Web runner
Future<void> run() async {
  sharedRun(
    InitializationHook.setup(),
  );
}
