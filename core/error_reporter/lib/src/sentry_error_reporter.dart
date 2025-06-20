import 'package:error_reporter/src/error_reporter.dart';
import 'package:flutter/foundation.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

/// {@template sentry_error_reporter}
/// Sentry implementation of [ErrorReporter].
/// {@endtemplate}
class SentryErrorReporter implements ErrorReporter {
  /// {@macro sentry_error_reporter}
  const SentryErrorReporter({required this.sentryDsn, required this.environment});

  /// The Sentry DSN.
  final String sentryDsn;

  /// The Sentry environment.
  final String environment;

  @override
  bool get isInitialized => Sentry.isEnabled;

  @override
  Future<void> initialize() async {
    await SentryFlutter.init(
      (options) => options
        ..dsn = sentryDsn
        ..tracesSampleRate = 0.10
        ..debug = kDebugMode
        ..environment = environment
        ..anrEnabled = true
        ..sendDefaultPii = true,
    );
  }

  @override
  Future<void> captureException({required Object throwable, StackTrace? stackTrace}) async {
    await Sentry.captureException(throwable, stackTrace: stackTrace);
  }

  @override
  Future<void> close() async {
    await Sentry.close();
  }
}
