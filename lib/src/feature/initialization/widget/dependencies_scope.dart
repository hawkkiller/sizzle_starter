import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sizzle_starter/src/core/utils/mixin/scope_mixin.dart';
import 'package:sizzle_starter/src/feature/initialization/model/dependencies.dart';

/// A widget which is responsible for providing the dependencies.
class DependenciesScope extends InheritedWidget {
  const DependenciesScope({
    required super.child,
    required this.dependencies,
    super.key,
  });

  final Dependencies dependencies;

  /// Get only dependencies from the widget
  static Dependencies dependenciesOf(BuildContext context) =>
      maybeOf(context) ??
      ScopeMixin.notFoundInheritedWidgetOfExactType<DependenciesScope>();

  /// Maybe get the dependencies from the widget
  ///
  /// The dependencies may not be present if they are not provided higher up in the tree.
  static Dependencies? maybeOf(BuildContext context) =>
      ScopeMixin.scopeMaybeOf<DependenciesScope>(
        context,
        listen: false,
      )?.dependencies;

  @override
  bool updateShouldNotify(DependenciesScope oldWidget) => false;
}
