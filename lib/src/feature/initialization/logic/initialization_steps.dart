import 'dart:async';

import 'package:blaze_starter/src/core/router/routes.dart';
import 'package:blaze_starter/src/feature/initialization/model/initialization_progress.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

typedef StepAction = FutureOr<InitializationProgress>? Function(
  InitializationProgress progress,
);
typedef StepDescription = String;

mixin InitializationSteps {
  final steps = <StepDescription, StepAction>{
    'Init Firebase': (progress) {},
    'Init Shared Preferences': (progress) async {
      final sharedPreferences = await SharedPreferences.getInstance();
      return progress.copyWith(
        preferences: sharedPreferences,
      );
    },
    'Init Router': (progress) {
      final router = GoRouter(
        observers: <NavigatorObserver>[
          SentryNavigatorObserver(),
          // FirebaseAnalyticsObserver(
          //   analytics: FirebaseAnalytics.instanceFor(app: d.app!),
          // ),
        ],
        routes: $appRoutes,
      );
      return progress.copyWith(
        router: router,
      );
    }
  };
}
