import 'package:flutter/material.dart';
import 'package:sizzle_starter/src/core/localization/app_localization.dart';
import 'package:sizzle_starter/src/core/router/app_router_scope.dart';
import 'package:sizzle_starter/src/core/theme/color_schemes.dart';

/// A widget which is responsible for providing the app context.
class AppContext extends StatefulWidget {
  const AppContext({super.key});

  @override
  State<AppContext> createState() => _AppContextState();
}

class _AppContextState extends State<AppContext> {
  @override
  Widget build(BuildContext context) {
    final router = AppRouterScope.of(context);
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
