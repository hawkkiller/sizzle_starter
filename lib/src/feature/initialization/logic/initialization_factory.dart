part of 'initialization_processor.dart';

abstract class InitializationFactory {
  IEnvironmentStore getEnvironmentStore();

  SentryTrackingManager createTrackingManager(
    IEnvironmentStore environmentStore,
  );
}

mixin InitializationFactoryImpl implements InitializationFactory {
  @override
  SentryTrackingManager createTrackingManager(
    IEnvironmentStore environmentStore,
  ) =>
      SentryTrackingManager(sentryDsn: environmentStore.sentryDsn);

  @override
  IEnvironmentStore getEnvironmentStore() => EnvironmentStore();
}
