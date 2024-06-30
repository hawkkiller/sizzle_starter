import 'package:flutter/material.dart';
import 'package:sizzle_starter/src/core/constant/localization/localization.dart';
import 'package:sizzle_starter/src/feature/home/widget/home_screen.dart';
import 'package:sizzle_starter/src/feature/settings/widget/settings_scope.dart';

/// {@template material_context}
/// [MaterialContext] is an entry point to the material context.
///
/// This widget sets locales, themes and routing.
/// {@endtemplate}
class MaterialContext extends StatelessWidget {
  /// {@macro material_context}
  const MaterialContext({super.key});

  // This global key is needed for [MaterialApp]
  // to work properly when Widgets Inspector is enabled.
  static final _globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final theme = SettingsScope.themeOf(context).theme;
    final locale = SettingsScope.localeOf(context).locale;
    final textScale = SettingsScope.textScaleOf(context).textScale;

    final mediaQueryData = MediaQuery.of(context);

    return MaterialApp(
      theme: theme.lightTheme,
      darkTheme: theme.darkTheme,
      themeMode: theme.mode,
      localizationsDelegates: Localization.localizationDelegates,
      supportedLocales: Localization.supportedLocales,
      locale: locale,
      home: const HomeScreen(),
      builder: (context, child) => MediaQuery(
        key: _globalKey,
        data: mediaQueryData.copyWith(
          textScaler: TextScaler.linear(
            mediaQueryData.textScaler.scale(textScale).clamp(0.5, 2),
          ),
        ),
        child: child!,
      ),
    );
  }
}
