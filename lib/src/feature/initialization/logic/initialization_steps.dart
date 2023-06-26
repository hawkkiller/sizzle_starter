import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizzle_starter/src/feature/initialization/model/dependencies.dart';

typedef StepAction = FutureOr<void>? Function(Dependencies$Mutable progress);

/// The initialization steps, which are executed in the order they are defined.
/// 
/// The [Dependencies] object is passed to each step, which allows the step to
/// set the dependency, and the next step to use it.
mixin InitializationSteps {
  final initializationSteps = <String, StepAction>{
    'Shared Preferences': (progress) async {
      final sharedPreferences = await SharedPreferences.getInstance();
      progress.sharedPreferences = sharedPreferences;
    },
  };
}
