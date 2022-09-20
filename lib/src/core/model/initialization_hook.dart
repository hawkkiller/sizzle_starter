abstract class InitializationHook {
  InitializationHook({
    this.onInit,
    this.onInitializing,
    this.onInitialized,
  });

  factory InitializationHook.setup({
    void Function()? onInit,
    void Function()? onInitializing,
    void Function()? onInitialized,
  }) = _Hook;

  void Function()? onInit;

  void Function()? onInitializing;

  void Function()? onInitialized;
}

class _Hook extends InitializationHook {
  _Hook({
    super.onInit,
    super.onInitializing,
    super.onInitialized,
  });
}
