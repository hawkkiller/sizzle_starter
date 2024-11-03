import 'package:sizzle_starter/src/feature/initialization/model/environment.dart';

/// Application configuration
class Config {
  /// Creates a new [Config] instance.
  const Config();

  /// The current environment.
  Environment get environment {
    var env = const String.fromEnvironment('ENVIRONMENT');

    if (env.isNotEmpty) {
      return Environment.from(env);
    }

    env = const String.fromEnvironment('FLUTTER_APP_FLAVOR');

    return Environment.from(env);
  }

  /// The Sentry DSN.
  String get sentryDsn => const String.fromEnvironment('SENTRY_DSN');

  /// Whether Sentry is enabled.
  bool get enableSentry => sentryDsn.isNotEmpty;
}

/// {@template testing_dependencies_container}
/// A special version of [Config] that is used in tests.
///
/// In order to use [Config] in tests, it is needed to
/// extend this class and provide the dependencies that are needed for the test.
/// {@endtemplate}
base class TestConfig implements Config {
  /// {@macro testing_dependencies_container}
  const TestConfig();

  @override
  Object noSuchMethod(Invocation invocation) {
    throw UnimplementedError(
      'The test tries to access ${invocation.memberName} config option, but '
      'it was not provided. Please provide the option in the test. '
      'You can do it by extending this class and providing the option.',
    );
  }
}
