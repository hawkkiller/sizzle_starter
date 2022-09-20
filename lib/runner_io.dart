import 'package:blaze_starter/runner_shared.dart';
import 'package:blaze_starter/src/core/model/initialization_hook.dart';

// I\O runner
Future<void> run() async {
  // there could be some I\O specific initialization here
  sharedRun(
    InitializationHook.setup(),
  );
}
