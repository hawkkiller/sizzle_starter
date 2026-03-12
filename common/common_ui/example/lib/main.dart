import 'package:common_translations/common_translations.dart';
import 'package:common_ui/common_ui.dart';
import 'package:example/ds_preview_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: CommonTranslations.localizationsDelegates,
      supportedLocales: CommonTranslations.supportedLocales,
      theme: SandgoldTheme().buildThemeData(),
      home: const DsPreviewScreen(),
    );
  }
}
