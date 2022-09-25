import 'dart:async';

import 'package:blaze_starter/src/core/router/routes.dart';
import 'package:blaze_starter/src/feature/initialization/model/initialization_progress.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

typedef StepAction = FutureOr<InitializationWrapper>? Function(
  InitializationWrapper wrapper,
  InitializationDependencies,
  InitializationRepositories,
);
typedef StepDescription = String;

mixin InitializationSteps {
  final steps = <StepDescription, StepAction>{
    'Init Firebase': (wrapper, p1, p2) async => wrapper.copyWith(
          dependencies: p1.copyWith(
              // app: await Firebase.initializeApp(
              //   options: const FirebaseOptions(
              //     apiKey: '',
              //     appId: '',
              //     messagingSenderId: '',
              //     projectId: '',
              //   ),
              // ),
              ),
        ),
    'Init Shared Preferences': (wrapper, dep, rep) async {
      final sharedPreferences = await SharedPreferences.getInstance();
      return wrapper.copyWith(
        dependencies: dep.copyWith(preferences: sharedPreferences),
      );
    },
    'Init Router': (wrapper, d, r) {
      final router = GoRouter(
        observers: <NavigatorObserver>[
          SentryNavigatorObserver(),
          // FirebaseAnalyticsObserver(
          //   analytics: FirebaseAnalytics.instanceFor(app: d.app!),
          // ),
        ],
        routes: $appRoutes,
      );
      return wrapper.copyWith(
        dependencies: d.copyWith(router: router),
      );
    }
  };
}
