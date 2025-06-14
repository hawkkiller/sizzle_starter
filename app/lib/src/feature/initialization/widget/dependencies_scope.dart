import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:settings/settings.dart';
import 'package:sizzle_starter/src/common/extensions/context_extension.dart';
import 'package:sizzle_starter/src/feature/initialization/model/dependencies_container.dart';

class DependenciesScope extends StatelessWidget {
  const DependenciesScope({required this.dependencies, required this.child, super.key});

  final DependenciesContainer dependencies;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DependenciesInherited(
      dependencies: dependencies,
      child: SettingsContainerInherited(
        settingsContainer: dependencies.settingsContainer,
        child: SettingsScope(child: child),
      ),
    );
  }
}

/// {@template dependencies_scope}
/// A scope that provides composed [DependenciesContainer].
///
/// **Testing**:
///
/// To use [DependenciesInherited] in tests, it is needed to wrap the widget with
/// [DependenciesInherited], extend [TestDependenciesContainer] and provide the
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
class DependenciesInherited extends InheritedWidget {
  /// {@macro dependencies_scope}
  const DependenciesInherited({required super.child, required this.dependencies, super.key});

  /// Container with dependencies.
  final DependenciesContainer dependencies;

  /// Get the dependencies from the [context].
  static DependenciesContainer of(BuildContext context) =>
      context.inhOf<DependenciesInherited>(listen: false).dependencies;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<DependenciesContainer>('dependencies', dependencies));
  }

  @override
  bool updateShouldNotify(DependenciesInherited oldWidget) {
    return !identical(dependencies, oldWidget.dependencies);
  }
}
