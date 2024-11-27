import 'dart:async';

import 'package:sizzle_starter/src/feature/initialization/logic/app_runner.dart';

Future<void> main() async {
  final appRunner = await AppRunner.create();

  await appRunner.startup();
}
