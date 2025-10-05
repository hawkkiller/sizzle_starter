import 'package:error_reporter/error_reporter.dart';
import 'package:logger/logger.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:settings/settings.dart';
import 'package:sizzle_starter/src/model/application_config.dart';

/// Container for global dependencies.
class DependenciesContainer {
  const DependenciesContainer({
    required this.logger,
    required this.config,
    required this.errorReporter,
    required this.packageInfo,
    required this.settingsContainer,
  });

  final Logger logger;
  final ApplicationConfig config;
  final ErrorReporter errorReporter;
  final PackageInfo packageInfo;
  final SettingsContainer settingsContainer;
}

/// A special version of [DependenciesContainer] that is used in tests.
///
/// In order to use [DependenciesContainer] in tests, it is needed to
/// extend this class and provide the dependencies that are needed for the test.
base class TestDependenciesContainer implements DependenciesContainer {
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
