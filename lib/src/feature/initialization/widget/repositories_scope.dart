import 'package:blaze_starter/src/core/utils/mixin/scope_mixin.dart';
import 'package:blaze_starter/src/feature/initialization/model/initialization_progress.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class RepositoriesScope extends InheritedWidget with ScopeMixin {
  const RepositoriesScope({
    required super.child,
    required this.repositories,
    super.key,
  });

  final ResultingRepositories repositories;

  static ResultingRepositories? maybeOf(BuildContext context) =>
      ScopeMixin.scopeMaybeOf<RepositoriesScope>(
        context,
        listen: false,
      )?.repositories;

  static ResultingRepositories of(BuildContext context) => maybeOf(context)!;

  @override
  bool updateShouldNotify(RepositoriesScope oldWidget) => false;
}
