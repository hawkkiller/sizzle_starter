import 'package:blaze_starter/src/core/utils/mixin/scope_mixin.dart';
import 'package:blaze_starter/src/feature/initialization/model/initialization_progress.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class DependenciesScope extends InheritedWidget with ScopeMixin {
  const DependenciesScope({
    required super.child,
    required this.dependencies,
    super.key,
  });

  final ResultingDependencies dependencies;

  static ResultingDependencies? maybeOf(BuildContext context) =>
      ScopeMixin.scopeMaybeOf<DependenciesScope>(
        context,
        listen: false,
      )?.dependencies;

  static ResultingDependencies of(BuildContext context) => maybeOf(context)!;

  @override
  bool updateShouldNotify(DependenciesScope oldWidget) => false;
}
