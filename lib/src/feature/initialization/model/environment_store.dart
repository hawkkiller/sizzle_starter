/// {@macro environment_store}
class EnvironmentStore {
  /// {@macro environment_store}
  const EnvironmentStore();

  /// The Sentry DSN.
  String get sentryDsn => const String.fromEnvironment('sentry_dsn');
}
