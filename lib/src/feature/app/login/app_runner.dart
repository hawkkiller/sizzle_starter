import 'package:blaze_starter/src/core/model/initialization_hook.dart';
import 'package:blaze_starter/src/core/widget/app.dart';
import 'package:flutter/material.dart';

mixin AppRunner {
  static void initializeAndRun(
    InitializationHook hook,
  ) {
    runApp(const App());
  }
}
