import 'package:flutter/foundation.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:sizzle_starter/src/core/utils/error_tracking_manager/error_tracking_manager.dart';
import 'package:sizzle_starter/src/core/utils/logger/logger.dart';
import 'package:sizzle_starter/src/feature/initialization/model/environment.dart';

/// {@template sentry_tracking_manager}
/// A class that is responsible for managing Sentry error tracking.
/// {@endtemplate}
final class SentryTrackingManager extends ErrorTrackingManagerBase {
  /// {@macro sentry_tracking_manager}
  SentryTrackingManager({
    required this.sentryDsn,
    required this.environment,
  });

  /// The Sentry DSN.
  final String sentryDsn;

  /// The Sentry environment.
  final Environment environment;

  @override
  Future<void> report(LogMessage log) async {
    final error = log.error;
    final stackTrace = log.stackTrace;

    if (error == null && stackTrace == null) {
      await Sentry.captureMessage(log.message, level: _logLevel(log.level));
      return;
    }

    await Sentry.captureException(
      error ?? log.message,
      stackTrace: stackTrace,
    );
  }

  @override
  Future<void> enableReporting() async {
    await SentryFlutter.init((options) {
      options.dsn = sentryDsn;

      // Set the sample rate to 10% of events.
      options.tracesSampleRate = 0.10;
      options.debug = kDebugMode;
      options.environment = environment.value;
      options.anrEnabled = true;
      options.sendDefaultPii = true;
    });
    await super.enableReporting();
  }

  @override
  Future<void> disableReporting() async {
    await Sentry.close();
    await super.disableReporting();
  }

  SentryLevel _logLevel(LogLevel level) => switch (level) {
        LogLevel.trace || LogLevel.debug => SentryLevel.debug,
        LogLevel.info => SentryLevel.info,
        LogLevel.warn => SentryLevel.warning,
        LogLevel.error => SentryLevel.error,
        LogLevel.fatal => SentryLevel.fatal,
      };
}
