import 'package:sizzle_starter/src/feature/initialization/model/enum/environment.dart';

abstract class IEnvironmentStore {
  abstract final Environment environment;
  abstract final String sentryDsn;

  bool get isProduction => environment == Environment.prod;
}

class EnvironmentStore extends IEnvironmentStore {
  EnvironmentStore();

  static final _env = Environment.fromEnvironment(
    const String.fromEnvironment('env'),
  );

  @override
  Environment get environment => _env;

  @override
  String get sentryDsn => const String.fromEnvironment('sentry_dsn');
}
