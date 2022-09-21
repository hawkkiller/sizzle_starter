import 'dart:async';

import 'package:blaze_starter/src/feature/initialization/model/initialization_progress.dart';
import 'package:shared_preferences/shared_preferences.dart';

typedef StepAction = FutureOr<InitializationWrapper> Function(
  InitializationWrapper wrapper,
  InitializationDependencies,
  InitializationRepositories,
);
typedef StepDescription = String;

mixin InitializationSteps {
  final steps = <StepDescription, StepAction>{
    'Init Shared Preferences': (wrapper, dependencies, repositories) async {
      final sp = await SharedPreferences.getInstance();
      return wrapper.copyWith(
        dependencies: dependencies.copyWith(preferences: sp),
      );
    }
  };
}
