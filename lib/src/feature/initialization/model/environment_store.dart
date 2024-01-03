import 'package:sizzle_starter/src/feature/initialization/model/environment.dart';

/// {@template environment_store}
/// Environment store
/// {@endtemplate}
class EnvironmentStore {
  /// {@macro environment_store}
  const EnvironmentStore();

  /// The Sentry DSN.
  String get sentryDsn => const String.fromEnvironment('SENTRY_DSN');

  /// The environment.
  Environment get environment {
    var environment = const String.fromEnvironment('ENVIRONMENT');

    if (environment.isNotEmpty) {
      return Environment.from(environment);
    }

    environment = const String.fromEnvironment('FLUTTER_APP_FLAVOR');

    return Environment.from(environment);
  }

  /// Whether Sentry is enabled.
  bool get enableTrackingManager => sentryDsn.isNotEmpty;
}
