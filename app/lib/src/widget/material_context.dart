import 'package:flutter/material.dart';
import 'package:sizzle_starter/src/feature/home/presentation/home_screen.dart';
import 'package:sizzle_starter/src/feature/settings/domain/model/general.dart';
import 'package:sizzle_starter/src/feature/settings/presentation/settings_scope.dart';
import 'package:sizzle_starter/src/widget/media_query_override.dart';

/// Entry point for the application that uses [MaterialApp].
class MaterialContext extends StatelessWidget {
  const MaterialContext({super.key});

  /// This global key is needed for Flutter to work properly
  /// when Widgets Inspector is enabled.
  static final _globalKey = GlobalKey(debugLabel: 'MaterialContext');

  @override
  Widget build(BuildContext context) {
    final settings = SettingsScope.of(context);
    final themeMode = settings.general.themeMode;
    final seedColor = settings.general.seedColor;
    final locale = settings.general.locale;

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
      locale: locale,
      home: const HomeScreen(),
      builder: (context, child) {
        return KeyedSubtree(
          key: _globalKey,
          child: MediaQueryRootOverride(child: child!),
        );
      },
    );
  }
}
