import 'package:example/src/previews/button_preview.dart';
import 'package:example/src/previews/card_preview.dart';
import 'package:example/src/previews/checkbox_preview.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ui_showcase/ui_showcase.dart';

void main() {
  runApp(const MyApp());
}

final showcaseNodes = [
  ShowcaseNode(name: 'Button', widget: const SomeButtonPreview()),
  ShowcaseNode(name: 'Card', widget: const CardPreview()),
  ShowcaseNode(name: 'Checkbox', widget: const CheckboxPreview()),
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
        createRootShowcaseRoute(
          nodes: showcaseNodes,
          builder: (context, child) => ThemeOptionProvider(
            options: [
              ThemeOption(name: 'Light', theme: ThemeData.light()),
              ThemeOption(name: 'Dark', theme: ThemeData.dark()),
            ],
            child: child,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) => MaterialApp.router(
    routerConfig: router,
    debugShowCheckedModeBanner: false,
  );
}
