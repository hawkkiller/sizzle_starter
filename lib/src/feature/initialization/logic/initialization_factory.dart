part of 'initialization_processor.dart';

abstract class InitializationFactory {
  EnvironmentStore getEnvironmentStore();

  SentryTrackingManager createTrackingManager(
    EnvironmentStore environmentStore,
  );
}

class InitializationFactoryImpl implements InitializationFactory {
  @override
  SentryTrackingManager createTrackingManager(
    EnvironmentStore environmentStore,
  ) =>
      SentryTrackingManager(
        sentryDsn: environmentStore.sentryDsn,
      );

  @override
  EnvironmentStore getEnvironmentStore() => EnvironmentStore();
}
