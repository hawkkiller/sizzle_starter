import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizzle_starter/src/core/router/router.dart';
import 'package:sizzle_starter/src/feature/initialization/model/initialization_progress.dart';

typedef StepAction = FutureOr<InitializationProgress>? Function(
  InitializationProgress progress,
);
typedef StepDescription = String;

mixin InitializationSteps {
  final initializationSteps = <StepDescription, StepAction>{
    ..._dependencies,
    ..._data,
  };
  static final _dependencies = <StepDescription, StepAction>{
    'Init Shared Preferences': (progress) async {
      final sharedPreferences = await SharedPreferences.getInstance();
      return progress.copyWith(
        preferences: sharedPreferences,
      );
    },
    'Init Router': (progress) {
      final router = AppRouter();
      return progress.copyWith(
        router: router,
      );
    }
  };
  static final _data = <StepDescription, StepAction>{};
}
