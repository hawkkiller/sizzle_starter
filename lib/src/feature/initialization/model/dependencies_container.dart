import 'package:sizzle_starter/src/core/utils/error_tracking_manager.dart';
import 'package:sizzle_starter/src/feature/initialization/logic/composition_root.dart';
import 'package:sizzle_starter/src/feature/settings/bloc/app_settings_bloc.dart';

/// {@template dependencies_container}
/// Composed dependencies from the [CompositionRoot].
///
/// This class contains all the dependencies that are required for the application
/// to work.
///
/// {@macro composition_process}
/// {@endtemplate}
base class DependenciesContainer {
  /// {@macro dependencies_container}
  const DependenciesContainer({
    required this.appSettingsBloc,
    required this.errorTrackingManager,
  });

  /// [AppSettingsBloc] instance, used to manage theme and locale.
  final AppSettingsBloc appSettingsBloc;

  /// [ErrorTrackingManager] instance, used to report errors.
  final ErrorTrackingManager errorTrackingManager;
}

/// {@template testing_dependencies_container}
/// A special version of [DependenciesContainer] that is used in tests.
///
/// In order to use [DependenciesContainer] in tests, it is needed to
/// extend this class and provide the dependencies that are needed for the test.
/// {@endtemplate}
base class TestDependenciesContainer implements DependenciesContainer {
  /// {@macro testing_dependencies_container}
  const TestDependenciesContainer();

  @override
  Object noSuchMethod(Invocation invocation) {
    throw UnimplementedError(
      'The test tries to access ${invocation.memberName} dependency, but '
      'it was not provided. Please provide the dependency in the test. '
      'You can do it by extending this class and providing the dependency.',
    );
  }
}
