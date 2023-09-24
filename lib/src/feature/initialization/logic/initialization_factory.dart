part of 'initialization_processor.dart';

/// {@template initialization_factory}
/// Factory for creating pre-initialized objects.
/// {@endtemplate}
abstract class InitializationFactory {
  /// Get the environment store.
  IEnvironmentStore getEnvironmentStore();

  /// Create a tracking manager.
  SentryTrackingManager createTrackingManager(
    IEnvironmentStore environmentStore,
  );
}

/// {@macro initialization_factory}
mixin InitializationFactoryImpl implements InitializationFactory {
  @override
  SentryTrackingManager createTrackingManager(
    IEnvironmentStore environmentStore,
  ) =>
      SentryTrackingManager(environmentStore.sentryDsn, logger);

  @override
  IEnvironmentStore getEnvironmentStore() => EnvironmentStore();
}
