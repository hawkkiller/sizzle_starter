import 'package:sizzle_starter/src/feature/initialization/model/enum/environment.dart';

/// {@template environment_store}
/// A class which is responsible for storing the environment.
/// {@endtemplate}
abstract interface class IEnvironmentStore {
  /// The environment.
  abstract final Environment environment;

  /// The Sentry DSN.
  abstract final String sentryDsn;

  /// Whether the environment is development.
  bool get isProduction => environment == Environment.prod;
}

/// {@macro environment_store}
class EnvironmentStore extends IEnvironmentStore {
  /// {@macro environment_store}
  EnvironmentStore();

  static final _env = Environment.fromString(
    const String.fromEnvironment('env'),
  );

  @override
  Environment get environment => _env;

  @override
  String get sentryDsn => const String.fromEnvironment('sentry_dsn');
}
