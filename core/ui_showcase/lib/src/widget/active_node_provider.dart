import 'package:flutter/material.dart';
import 'package:ui_showcase/ui_showcase.dart';

class ActiveNodeProvider extends InheritedWidget {
  const ActiveNodeProvider({
    required this.activeNode,
    required super.child,
    super.key,
  });

  final ShowcaseNode? activeNode;

  static ActiveNodeProvider? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ActiveNodeProvider>();
  }

  static ActiveNodeProvider of(BuildContext context) {
    final result = maybeOf(context);
    assert(result != null, 'No ActiveNodeProvider found in context');

    return result!;
  }

  @override
  bool updateShouldNotify(ActiveNodeProvider oldWidget) {
    return activeNode != oldWidget.activeNode;
  }
}
