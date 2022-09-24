import 'dart:async';

import 'package:blaze_starter/src/core/router/routes.dart';
import 'package:blaze_starter/src/feature/initialization/model/initialization_progress.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

typedef StepAction = FutureOr<InitializationWrapper> Function(
  InitializationWrapper wrapper,
  InitializationDependencies,
  InitializationRepositories,
);
typedef StepDescription = String;

mixin InitializationSteps {
  final steps = <StepDescription, StepAction>{
    'Init Shared Preferences': (wrapper, dep, rep) async {
      final sharedPreferences = await SharedPreferences.getInstance();
      return wrapper.copyWith(
        dependencies: dep.copyWith(preferences: sharedPreferences),
      );
    },
    'Init Router': (wrapper, d, r) {
      final router = GoRouter(
        routes: $appRoutes,
      );
      return wrapper.copyWith(
        dependencies: d.copyWith(router: router),
      );
    }
  };
}
