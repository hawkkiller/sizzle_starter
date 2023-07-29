import 'package:flutter/material.dart';
import 'package:sizzle_starter/src/core/localization/app_localization.dart';
import 'package:sizzle_starter/src/core/theme/theme.dart';
import 'package:sizzle_starter/src/feature/sample/widget/sample_screen.dart';

/// A widget which is responsible for providing the app context.
class AppContext extends StatefulWidget {
  const AppContext({super.key});

  @override
  State<AppContext> createState() => _AppContextState();
}

class _AppContextState extends State<AppContext> {
  @override
  Widget build(BuildContext context) => MaterialApp(
        supportedLocales: AppLocalization.supportedLocales,
        localizationsDelegates: AppLocalization.localizationsDelegates,
        theme: $lightThemeData,
        darkTheme: $darkThemeData,
        locale: const Locale('es'),
        home: const SampleScreen(),
      );
}
