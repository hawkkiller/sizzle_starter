import 'package:sizzle_starter/runner_shared.dart';
import 'package:sizzle_starter/src/feature/initialization/model/initialization_hook.dart';

// Web runner
Future<void> run() async {
  // there could be some web specific initialization here
  sharedRun(
    InitializationHook.setup(),
  );
}
