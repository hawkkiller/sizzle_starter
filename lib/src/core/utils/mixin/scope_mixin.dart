import 'package:flutter/material.dart';

abstract class ChildContainer {
  Widget? get child;
}

/// A mixin which provides some useful methods for working with inherited widgets.
/// If you need to get a scope from the context, use [scopeMaybeOf] or [scopeOf].
/// Also, use this Mixin if you want to provide a scope to descendants.
mixin ScopeMixin<T extends Widget> on Widget implements ChildContainer {
  static T? scopeMaybeOf<T extends InheritedWidget>(
    BuildContext context, {
    bool listen = true,
  }) {
    T? inhW;
    if (listen) {
      inhW = context.dependOnInheritedWidgetOfExactType<T>();
    } else {
      inhW = context.getElementForInheritedWidgetOfExactType<T>()?.widget as T?;
    }
    return inhW;
  }

  static T scopeOf<T extends InheritedWidget>(
    BuildContext context, {
    bool listen = true,
  }) =>
      scopeMaybeOf<T>(context, listen: listen) ??
      notFoundInheritedWidgetOfExactType<T>();

  static Never
      notFoundInheritedWidgetOfExactType<T extends InheritedWidget>() =>
          throw ArgumentError(
            'Out of scope, not found inherited widget '
                'a $T of the exact type',
            'out_of_scope',
          );
}
