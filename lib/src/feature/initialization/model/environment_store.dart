/// {@template environment_store}
/// A class which is responsible for storing the environment.
/// {@endtemplate}
abstract interface class IEnvironmentStore {
  /// The Sentry DSN.
  abstract final String sentryDsn;
}

/// {@macro environment_store}
class EnvironmentStore extends IEnvironmentStore {
  /// {@macro environment_store}
  EnvironmentStore();

  @override
  String get sentryDsn => const String.fromEnvironment('sentry_dsn');
}
