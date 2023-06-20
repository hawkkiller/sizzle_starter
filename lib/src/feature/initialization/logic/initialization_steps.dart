import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizzle_starter/src/core/router/router.dart';
import 'package:sizzle_starter/src/feature/initialization/model/dependencies.dart';

typedef StepAction = FutureOr<void>? Function(Dependencies$Mutable progress);

///
mixin InitializationSteps {
  final initializationSteps = <String, StepAction>{
    'Shared Preferences': (progress) async {
      final sharedPreferences = await SharedPreferences.getInstance();
      progress.sharedPreferences = sharedPreferences;
    },
    'App Router': (progress) {
      final router = AppRouter();
      progress.router = router;
    }
  };
}
