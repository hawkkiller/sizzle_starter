import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sizzle_starter/src/core/utils/mixin/scope_mixin.dart';
import 'package:sizzle_starter/src/feature/initialization/model/initialization_progress.dart';

abstract class StoresContainer {
  DependenciesStore get dependencies;
  RepositoriesStore get repositories;
}

/// A widget which is responsible for providing the dependencies.
class DependenciesScope extends InheritedWidget with ScopeMixin implements StoresContainer {
  const DependenciesScope({
    required super.child,
    required this.dependencies,
    required this.repositories,
    super.key,
  });

  @override
  final DependenciesStore dependencies;

  @override
  final RepositoriesStore repositories;

  /// Get only dependencies from the widget
  static DependenciesStore dependenciesOf(BuildContext context) =>
      _maybeOf(context)?.dependencies ??
      ScopeMixin.notFoundInheritedWidgetOfExactType<DependenciesScope>();

  /// Get only repositories from the widget
  static RepositoriesStore repositoriesOf(BuildContext context) =>
      _maybeOf(context)?.repositories ??
      ScopeMixin.notFoundInheritedWidgetOfExactType<DependenciesScope>();

  static StoresContainer? _maybeOf(BuildContext context) =>
      ScopeMixin.scopeMaybeOf<DependenciesScope>(
        context,
        listen: false,
      );

  static StoresContainer of(BuildContext context) =>
      _maybeOf(context) ?? ScopeMixin.notFoundInheritedWidgetOfExactType<DependenciesScope>();

  @override
  bool updateShouldNotify(DependenciesScope oldWidget) => false;
}
