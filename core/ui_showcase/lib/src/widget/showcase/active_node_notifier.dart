import 'package:flutter/material.dart';
import 'package:ui_showcase/ui_showcase.dart';

abstract class NodeRouter implements Listenable {
  void updateActiveNode(ShowcaseNode? node);

  ShowcaseNode? get activeNode;
}

class ActiveNodeNotifier extends InheritedNotifier {
  const ActiveNodeNotifier({
    required this.nodeRouter,
    required super.child,
  }) : super(notifier: nodeRouter);

  final NodeRouter nodeRouter;

  static ActiveNodeNotifier of(BuildContext context, {bool listen = true}) {
    final widget = listen
        ? context.dependOnInheritedWidgetOfExactType<ActiveNodeNotifier>()
        : context.getInheritedWidgetOfExactType<ActiveNodeNotifier>();

    if (widget == null) {
      throw FlutterError('No ActiveNodeNotifier found in context');
    }

    return widget;
  }

  ShowcaseNode? get activeNode => nodeRouter.activeNode;

  void updateActiveNode(ShowcaseNode? node) => nodeRouter.updateActiveNode(node);
}
