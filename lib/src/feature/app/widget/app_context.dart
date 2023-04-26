import 'package:flutter/material.dart';
import 'package:sizzle_starter/src/core/localization/app_localization.dart';
import 'package:sizzle_starter/src/core/theme/color_schemes.dart';
import 'package:sizzle_starter/src/feature/initialization/widget/dependencies_scope.dart';

/// A widget which is responsible for providing the app context.
class AppContext extends StatelessWidget {
  const AppContext({super.key});

  @override
  Widget build(BuildContext context) {
    final router = DependenciesScope.dependenciesOf(context).router;
    return MaterialApp.router(
      routerConfig: router.config(),
      supportedLocales: AppLocalization.supportedLocales,
      localizationsDelegates: AppLocalization.localizationsDelegates,
      theme: lightThemeData,
      darkTheme: darkThemeData,
      locale: const Locale('es'),
    );
  }
}
