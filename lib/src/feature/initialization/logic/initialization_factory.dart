part of 'initialization_processor.dart';

/// {@template initialization_factory}
/// Factory for creating pre-initialized objects.
/// {@endtemplate}
abstract class InitializationFactory {
  /// Get the environment store.
  EnvironmentStore getEnvironmentStore();

  /// Create a tracking manager.
  SentryTrackingManager createTrackingManager(
    EnvironmentStore environmentStore,
  );
}

/// {@macro initialization_factory}
mixin InitializationFactoryImpl implements InitializationFactory {
  @override
  SentryTrackingManager createTrackingManager(
    EnvironmentStore environmentStore,
  ) =>
      SentryTrackingManager(environmentStore.sentryDsn, logger);

  @override
  EnvironmentStore getEnvironmentStore() => const EnvironmentStore();
}
