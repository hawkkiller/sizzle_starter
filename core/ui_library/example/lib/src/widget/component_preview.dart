import 'package:device_preview/device_preview.dart';
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
          return DevicePreview(
            isToolbarVisible: false,
            builder: (context) {
              return MaterialApp(
                theme: theme,
                // ignore: deprecated_member_use
                useInheritedMediaQuery: true,
                home: Scaffold(body: Center(child: child)),
                builder: DevicePreview.appBuilder,
              );
            },
          );
        },
      );
    },
  );
}
