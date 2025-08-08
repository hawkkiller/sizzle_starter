import 'package:example/src/widget/sidebar.dart';
import 'package:example/src/widget/theme_switcher.dart';
import 'package:flutter/material.dart';
import 'package:ui_showcase/ui_showcase.dart';

class ComponentPreview extends StatelessWidget {
  const ComponentPreview({
    required this.inputs,
    required this.builder,
    super.key,
  });

  final List<InputWidget> inputs;
  final WidgetBuilder builder;

  @override
  Widget build(BuildContext context) => ThemeOptionInherited(
    builder: (context, theme) {
      return ShowcaseNodePreview(
        builder: builder,
        listenables: inputs.map((e) => e.listenable).toList(growable: false),
        sidebar: Sidebar(children: inputs),
        wrapWith: (child) {
          return MaterialApp(
            theme: theme,
            home: Scaffold(body: Center(child: child)),
          );
        },
      );
    },
  );
}
