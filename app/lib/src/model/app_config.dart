import 'package:sizzle_starter/src/model/app_env.dart';

/// App configuration
/// 
/// Configurations are read from environment variables, which are set with --dart-define.
class AppConfig {
  /// Creates a new [AppConfig] instance.
  const AppConfig();

  /// The current environment.
  AppEnv get environment {
    var env = const String.fromEnvironment('ENVIRONMENT').trim();

    if (env.isNotEmpty) {
      return AppEnv.from(env);
    }

    env = const String.fromEnvironment('FLUTTER_APP_FLAVOR').trim();

    return AppEnv.from(env);
  }

  /// The Sentry DSN.
  String get sentryDsn => const String.fromEnvironment('SENTRY_DSN').trim();

  /// Whether Sentry is enabled.
  bool get enableSentry => sentryDsn.isNotEmpty;
}

/// A special version of [AppConfig] that is used in tests.
///
/// In order to use [AppConfig] in tests, it is needed to
/// extend this class and provide the dependencies that are needed for the test.
base class TestConfig implements AppConfig {
  const TestConfig();

  @override
  Object noSuchMethod(Invocation invocation) {
    throw UnimplementedError(
      'The test tries to access ${invocation.memberName} (${invocation.runtimeType}) config option, but '
      'it was not provided. Please provide the option in the test. '
      'You can do it by extending this class and providing the option.',
    );
  }
}
