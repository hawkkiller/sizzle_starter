import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sizzle_starter/src/core/utils/extensions/context_extension.dart';
import 'package:sizzle_starter/src/feature/initialization/model/dependencies_container.dart';

/// {@template dependencies_scope}
/// A scope that provides composed [DependenciesContainer].
///
/// **Testing**:
///
/// To use [DependenciesScope] in tests, it is needed to wrap the widget with
/// [DependenciesScope], extend [TestDependenciesContainer] and provide the
/// dependencies that are needed for the test.
///
/// ```dart
/// class AuthDependenciesContainer extends TestDependenciesContainer {
///   // for example, use mocks created by mockito, or pass fake/real implementations
///   // via constructor.
///   @override
///   final MockAuthRepository authRepository = MockAuthRepository();
/// }
/// ```
/// {@endtemplate}
class DependenciesScope extends InheritedWidget {
  /// {@macro dependencies_scope}
  const DependenciesScope({
    required super.child,
    required this.dependencies,
    super.key,
  });

  /// Container with dependencies.
  final DependenciesContainer dependencies;

  /// Get the dependencies from the [context].
  static DependenciesContainer of(BuildContext context) =>
      context.inhOf<DependenciesScope>(listen: false).dependencies;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      DiagnosticsProperty<DependenciesContainer>('dependencies', dependencies),
    );
  }

  @override
  bool updateShouldNotify(DependenciesScope oldWidget) => false;
}
