import 'package:blaze_starter/src/core/enum/environment.dart';

abstract class IEnvironmentStore {
  abstract final Environment environment;
  abstract final String sentryDsn;
}

class EnvironmentStore implements IEnvironmentStore {
  EnvironmentStore();

  @override
  Environment get environment => Environment.fromEnvironment(
        const String.fromEnvironment('env'),
      );

  @override
  String get sentryDsn => const String.fromEnvironment('sentry_dsn');
}
