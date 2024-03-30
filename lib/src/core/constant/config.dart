import 'package:sizzle_starter/src/feature/initialization/model/environment.dart';

/// Application configuration
abstract interface class AppConfig {
  /// Application environment
  Environment get environment;

  /// Sentry dsn
  String get sentryDsn;

  /// If [sentryDsn] is not empty, then Sentry should be enabled.
  bool get enableSentry;
}

/// Application configuration
class Config implements AppConfig {
  /// Creates a new [Config] instance.
  const Config();

  @override
  Environment get environment {
    var environment = const String.fromEnvironment('ENVIRONMENT');

    if (environment.isNotEmpty) {
      return Environment.from(environment);
    }

    environment = const String.fromEnvironment('FLUTTER_APP_FLAVOR');

    return Environment.from(environment);
  }

  @override
  String get sentryDsn => const String.fromEnvironment('SENTRY_DSN');

  @override
  bool get enableSentry => sentryDsn.isNotEmpty;
}
