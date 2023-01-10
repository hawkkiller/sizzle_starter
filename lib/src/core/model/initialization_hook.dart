import 'package:sizzle_starter/src/feature/initialization/model/initialization_progress.dart';

/// A hook for the initialization process.
///
/// The [onInit] is called before the initialization process starts.
///
/// The [onInitializing] is called when the initialization process is in progress.
///
/// The [onInitialized] is called when the initialization process is finished.
///
/// The [onError] is called when the initialization process is failed.
abstract class InitializationHook {
  InitializationHook({
    this.onInit,
    this.onInitializing,
    this.onInitialized,
    this.onError,
  });

  factory InitializationHook.setup({
    void Function()? onInit,
    void Function(InitializationProgress)? onInitializing,
    void Function(InitializationResult)? onInitialized,
    void Function(int)? onError,
  }) = _Hook;

  void Function()? onInit;

  void Function(InitializationProgress)? onInitializing;

  void Function(InitializationResult)? onInitialized;

  void Function(int)? onError;
}

class _Hook extends InitializationHook {
  _Hook({
    super.onInit,
    super.onInitializing,
    super.onInitialized,
    super.onError,
  });
}
