import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:sizzle_starter/src/core/utils/refined_logger.dart';

/// {@template error_tracking_manager}
/// A class which is responsible for enabling error tracking.
/// {@endtemplate}
abstract interface class ErrorTrackingManager {
  /// Handles the log message.
  ///
  /// This method is called when a log message is received.
  Future<void> report(LogMessage log);

  /// Enables error tracking.
  ///
  /// This method should be called when the user has opted in to error tracking.
  Future<void> enableReporting();

  /// Disables error tracking.
  ///
  /// This method should be called when the user has opted out of error tracking
  Future<void> disableReporting();
}

/// {@template error_tracking_manager_base}
/// A class that is responsible for managing Sentry error tracking.
/// {@endtemplate}
abstract base class ErrorTrackingManagerBase implements ErrorTrackingManager {
  /// {@macro error_tracking_manager_base}
  ErrorTrackingManagerBase(this._logger);

  final RefinedLogger _logger;
  StreamSubscription<LogMessage>? _subscription;

  /// Catch only warnings and errors
  Stream<LogMessage> get _reportLogs => _logger.logs.where(_warnOrUp);

  static bool _warnOrUp(LogMessage log) => log.level.severity >= LogLevel.warn.severity;

  @mustCallSuper
  @mustBeOverridden
  @override
  Future<void> disableReporting() async {
    await _subscription?.cancel();
    _subscription = null;
  }

  @mustCallSuper
  @mustBeOverridden
  @override
  Future<void> enableReporting() async {
    _subscription ??= _reportLogs.listen((log) async {
      if (shouldReport(log.error)) {
        await report(log);
      }
    });
  }

  /// Returns `true` if the error should be reported.
  @pragma('vm:prefer-inline')
  bool shouldReport(Object? error) => true;
}

/// {@template sentry_tracking_manager}
/// A class that is responsible for managing Sentry error tracking.
/// {@endtemplate}
final class SentryTrackingManager extends ErrorTrackingManagerBase {
  /// {@macro sentry_tracking_manager}
  SentryTrackingManager(
    super._logger, {
    required this.sentryDsn,
    required this.environment,
  });

  /// The Sentry DSN.
  final String sentryDsn;

  /// The Sentry environment.
  final String environment;

  @override
  Future<void> report(LogMessage log) async {
    final error = log.error;
    final stackTrace = log.stackTrace;
    final hint = log.context != null ? Hint.withMap(log.context!) : null;

    if (error == null && stackTrace == null) {
      await Sentry.captureMessage(
        log.message,
        level: _logLevel(log.level),
        hint: hint,
      );
      return;
    }

    await Sentry.captureException(
      error ?? log.message,
      stackTrace: stackTrace,
      hint: hint,
    );
  }

  @override
  Future<void> enableReporting() async {
    await SentryFlutter.init((options) {
      options.dsn = sentryDsn;

      // Set the sample rate to 10% of events.
      options.tracesSampleRate = 0.10;
      options.debug = kDebugMode;
      options.environment = environment;
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
