import 'package:flutter/material.dart';

mixin ScopeMixin on InheritedWidget {
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
      _notFoundInheritedWidgetOfExactType<T>();

  static Never
      _notFoundInheritedWidgetOfExactType<T extends InheritedWidget>() =>
          throw ArgumentError(
            'Out of scope, not found inherited widget '
                'a $T of the exact type',
            'out_of_scope',
          );
}
