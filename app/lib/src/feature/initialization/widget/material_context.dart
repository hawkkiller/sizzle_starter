import 'package:flutter/material.dart';
import 'package:settings_api/settings_api.dart';
import 'package:sizzle_starter/src/feature/initialization/widget/media_query_override.dart';

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
  static final _globalKey = GlobalKey(debugLabel: 'MaterialContext');

  @override
  Widget build(BuildContext context) {
    final settings = SettingsScope.settingsOf(context);
    final themeMode = settings.themeConfiguration?.themeMode ?? ThemeModeVO.system;
    final seedColor = settings.themeConfiguration?.seedColor ?? Colors.blue;

    final materialThemeMode = switch (themeMode) {
      ThemeModeVO.system => ThemeMode.system,
      ThemeModeVO.light => ThemeMode.light,
      ThemeModeVO.dark => ThemeMode.dark,
    };

    final darkTheme = ThemeData(colorSchemeSeed: seedColor, brightness: Brightness.dark);
    final lightTheme = ThemeData(colorSchemeSeed: seedColor, brightness: Brightness.light);

    return MaterialApp(
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: materialThemeMode,
      locale: settings.locale,
      home: const Placeholder(),
      builder: (context, child) {
        return KeyedSubtree(
          key: _globalKey,
          child: MediaQueryRootOverride(child: child!),
        );
      },
    );
  }
}
