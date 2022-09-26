import 'package:blaze_starter/src/feature/initialization/model/initialization_progress.dart';

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
