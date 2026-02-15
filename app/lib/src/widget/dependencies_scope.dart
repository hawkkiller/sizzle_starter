import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sizzle_starter/src/feature/settings/presentation/settings_scope.dart';
import 'package:sizzle_starter/src/model/dependencies_container.dart';

/// A scope that provides [DependenciesContainer] to the application.
class DependenciesScope extends StatelessWidget {
  const DependenciesScope({
    required this.dependencies,
    required this.child,
    super.key,
  });

  /// Container with dependencies.
  final DependenciesContainer dependencies;

  /// The widget below this widget in the tree.
  final Widget child;

  /// Get the dependencies from the [context].
  static DependenciesContainer of(BuildContext context) =>
      context.inhOf<_DependenciesInherited>(listen: false).dependencies;

  @override
  Widget build(BuildContext context) {
    return _DependenciesInherited(
      dependencies: dependencies,
      child: SettingsScope(child: child),
    );
  }
}

/// A scope that provides composed [DependenciesContainer].
class _DependenciesInherited extends InheritedWidget {
  const _DependenciesInherited({required super.child, required this.dependencies});

  /// Container with dependencies.
  final DependenciesContainer dependencies;

  @override
  bool updateShouldNotify(_DependenciesInherited oldWidget) {
    return !identical(dependencies, oldWidget.dependencies);
  }
}
