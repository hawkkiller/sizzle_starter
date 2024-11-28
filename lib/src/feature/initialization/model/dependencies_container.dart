import 'package:package_info_plus/package_info_plus.dart';
import 'package:sizzle_starter/src/core/constant/application_config.dart';
import 'package:sizzle_starter/src/core/utils/error_reporter/error_reporter.dart';
import 'package:sizzle_starter/src/core/utils/logger/logger.dart';
import 'package:sizzle_starter/src/feature/settings/bloc/app_settings_bloc.dart';

/// {@template dependencies_container}
/// Container used to reuse dependencies across the application.
///
/// {@macro composition_process}
/// {@endtemplate}
class DependenciesContainer {
  /// {@macro dependencies_container}
  const DependenciesContainer({
    required this.logger,
    required this.config,
    required this.appSettingsBloc,
    required this.errorReporter,
    required this.packageInfo,
  });

  /// [Logger] instance, used to log messages.
  final Logger logger;

  /// [ApplicationConfig] instance, contains configuration of the application.
  final ApplicationConfig config;

  /// [AppSettingsBloc] instance, used to manage theme and locale.
  final AppSettingsBloc appSettingsBloc;

  /// [ErrorReporter] instance, used to report errors.
  final ErrorReporter errorReporter;

  /// [PackageInfo] instance, contains information about the application.
  final PackageInfo packageInfo;
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
