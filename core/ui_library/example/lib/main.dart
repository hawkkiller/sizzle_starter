import 'package:example/src/previews/button_preview.dart';
import 'package:flutter/material.dart';
import 'package:ui_showcase/ui_showcase.dart';

void main() {
  runApp(const MyApp());
}

final showcaseNodes = [
  ShowcaseFolderNode(
    name: 'Button',
    children: [
      ShowcasePreviewNode(name: 'Variant 1', widget: const SomeButtonPreview()),
      ShowcasePreviewNode(name: 'Variant 2', widget: const SomeButtonPreview()),
      ShowcasePreviewNode(name: 'Variant 3', widget: const SomeButtonPreview()),
      ShowcaseFolderNode(
        name: 'Folder',
        children: [
          ShowcasePreviewNode(name: 'Variant 1', widget: const SomeButtonPreview()),
          ShowcasePreviewNode(name: 'Variant 2', widget: const SomeButtonPreview()),
        ],
      ),
    ],
  ),
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
    router = createRouter(showcaseNodes);
  }

  @override
  Widget build(BuildContext context) {
    final darkTheme = ThemeData.dark();
    final lightTheme = ThemeData.light();

    return MaterialApp.router(
      routerConfig: router,
      theme: lightTheme,
      darkTheme: darkTheme,
    );
  }
}
