import 'package:example/src/previews/button_preview.dart';
import 'package:example/src/widget/theme_switcher.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ui_showcase/ui_showcase.dart';

void main() {
  runApp(const MyApp());
}

final showcaseNodes = [
  ShowcaseNode(name: 'Button', widget: const SomeButtonPreview()),
];

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final RouterConfig<Object> router;

  @override
  void initState() {
    super.initState();
    router = GoRouter(
      routes: [
        createRootShowcaseRoute(showcaseNodes),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ThemeOptionInherited(
      builder: (context, theme) => MaterialApp.router(
        routerConfig: router,
        theme: theme,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
