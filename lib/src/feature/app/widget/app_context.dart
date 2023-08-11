import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:sizzle_starter/src/core/localization/app_localization.dart';
import 'package:sizzle_starter/src/core/theme/theme.dart';
import 'package:sizzle_starter/src/feature/home/widget/home_screen.dart';

/// A widget which is responsible for providing the app context.
class AppContext extends StatefulWidget {
  const AppContext({super.key});

  @override
  State<AppContext> createState() => _AppContextState();
}

class _AppContextState extends State<AppContext> {
  @override
  Widget build(BuildContext context) => MaterialApp(
        supportedLocales: Localization.supportedLocales,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          Localization.localizationDelegate,
        ],
        theme: $lightThemeData,
        darkTheme: $darkThemeData,
        locale: const Locale('es'),
        home: const HomeScreen(),
      );
}
