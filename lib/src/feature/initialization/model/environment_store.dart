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
  Environment get environment => Environment.from(
        String.fromEnvironment(
          'ENVIRONMENT',
          defaultValue: Environment.dev.value,
        ),
      );

  /// Whether Sentry is enabled.
  bool get enableSentry => sentryDsn.isNotEmpty;
}
