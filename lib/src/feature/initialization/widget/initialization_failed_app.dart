import 'package:flutter/material.dart';

/// {@template initialization_failed_screen}
/// Screen that is shown when the initialization of the app fails.
/// {@endtemplate}
class InitializationFailedApp extends StatefulWidget {
  /// The error that caused the initialization to fail.
  final Object error;

  /// The stack trace of the error that caused the initialization to fail.
  final StackTrace stackTrace;

  /// The callback that will be called when the retry button is pressed.
  ///
  /// If null, the retry button will not be shown.
  final Future<void> Function()? onRetryInitialization;

  /// {@macro initialization_failed_screen}
  const InitializationFailedApp({
    required this.error,
    required this.stackTrace,
    this.onRetryInitialization,
    super.key,
  });

  @override
  State<InitializationFailedApp> createState() => _InitializationFailedAppState();
}

class _InitializationFailedAppState extends State<InitializationFailedApp> {
  /// Whether the initialization is in progress.
  final _inProgress = ValueNotifier<bool>(false);

  @override
  void dispose() {
    _inProgress.dispose();
    super.dispose();
  }

  Future<void> _retryInitialization() async {
    _inProgress.value = true;
    await widget.onRetryInitialization?.call();
    _inProgress.value = false;
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
        home: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Initialization failed',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    if (widget.onRetryInitialization != null)
                      IconButton(
                        icon: const Icon(Icons.refresh),
                        onPressed: _retryInitialization,
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  '${widget.error}',
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(color: Theme.of(context).colorScheme.error),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    '${widget.stackTrace}',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}
