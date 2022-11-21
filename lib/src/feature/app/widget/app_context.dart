import 'package:blaze_starter/src/core/localization/app_localization.dart';
import 'package:blaze_starter/src/feature/initialization/widget/dependencies_scope.dart';
import 'package:flutter/material.dart';

class AppContext extends StatelessWidget {
  const AppContext({super.key});

  @override
  Widget build(BuildContext context) {
    final router = DependenciesScope.of(context).router;
    return MaterialApp.router(
      routeInformationParser: router.defaultRouteParser(),
      routeInformationProvider: router.routeInfoProvider(),
      routerDelegate: router.delegate(),
      supportedLocales: AppLocalization.supportedLocales,
      localizationsDelegates: AppLocalization.localizationsDelegates,
    );
  }
}
