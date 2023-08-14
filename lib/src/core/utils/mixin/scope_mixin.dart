import 'package:flutter/material.dart';

/// {@template scope_mixin}
/// Provides useful tools for working with [InheritedWidget].
/// {@endtemplate}
mixin ScopeMixin<T extends Widget> on Widget {
  /// {@template scope_maybe_of}
  /// Obtain the nearest widget of the given type T,
  /// which must be the type of a concrete [InheritedWidget] subclass,
  /// and register this build context with that widget such that
  /// when that widget changes (or a new widget of that type is introduced,
  /// or the widget goes away), this build context is rebuilt so that it can
  /// obtain new values from that widget.
  /// {@endtemplate}
  static T? scopeMaybeOf<T extends InheritedWidget>(
    BuildContext context, {
    bool listen = true,
  }) =>
      listen
          ? context.dependOnInheritedWidgetOfExactType<T>()
          : context.getInheritedWidgetOfExactType<T>();

  /// {@macro scope_maybe_of}
  /// If the widget is not found, an exception will be thrown.
  static T scopeOf<T extends InheritedWidget>(
    BuildContext context, {
    bool listen = true,
  }) =>
      scopeMaybeOf<T>(context, listen: listen) ??
      notFoundInheritedWidgetOfExactType<T>();

  /// {@template not_found_inherited_widget_of_exact_type}
  /// This throws an exception when there is
  /// no inherited widget of the exact type.
  /// {@endtemplate}
  static Never
      notFoundInheritedWidgetOfExactType<T extends InheritedWidget>() =>
          throw ArgumentError(
            'Out of scope, not found inherited widget '
                'a $T of the exact type',
            'out_of_scope',
          );
}
