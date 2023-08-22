import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sizzle_starter/src/core/utils/mixin/scope_mixin.dart';
import 'package:sizzle_starter/src/feature/initialization/model/dependencies.dart';

/// {@template dependencies_scope}
/// A widget which is responsible for providing the dependencies.
/// {@endtemplate}
class DependenciesScope extends InheritedWidget {
  /// {@macro dependencies_scope}
  const DependenciesScope({
    required super.child,
    required this.dependencies,
    super.key,
  });

  /// The dependencies
  final Dependencies dependencies;

  /// Get the dependencies from the [context].
  static Dependencies of(BuildContext context) =>
      ScopeMixin.scopeOf<DependenciesScope>(context, listen: false)
          .dependencies;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      DiagnosticsProperty<Dependencies>('dependencies', dependencies),
    );
  }

  @override
  bool updateShouldNotify(DependenciesScope oldWidget) => false;
}
