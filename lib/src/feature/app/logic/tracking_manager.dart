import 'dart:async';

import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:sizzle_starter/src/core/utils/logger.dart';

/// A class which is responsible for disabling error tracking.
abstract class ErrorTrackingDisabler {
  /// Disables error tracking.
  Future<void> disableReporting();
}

/// {@template error_tracking_manager}
/// A class which is responsible for enabling error tracking.
/// {@endtemplate}
abstract class ErrorTrackingManager implements ErrorTrackingDisabler {
  /// Enables error tracking.
  void enableReporting();
}

/// {@template sentry_tracking_manager}
/// A class that is responsible for managing Sentry error tracking.
/// {@endtemplate}
abstract base class ErrorTrackingManagerBase implements ErrorTrackingManager {
  /// {@macro sentry_tracking_manager}
  ErrorTrackingManagerBase();

  StreamSubscription<LogMessage>? _subscription;

  /// Catch only warnings and errors
  static Stream<LogMessage> get _warningsAndErrors =>
      logger.logs.where(_isWarningOrError);

  static bool _isWarningOrError(LogMessage log) => switch (log.logLevel) {
        LoggerLevel.error => true,
        LoggerLevel.warning => true,
        _ => false,
      };

  @override
  Future<void> disableReporting() async {
    await _subscription?.cancel();
    _subscription = null;
  }

  @override
  void enableReporting() {
    _subscription ??= _warningsAndErrors.listen(sendReportingData);
  }

  /// Handles the log message.
  Future<void> sendReportingData(LogMessage log);
}

/// {@template sentry_tracking_manager}
/// A class that is responsible for managing Sentry error tracking.
/// {@endtemplate}
final class SentryTrackingManager extends ErrorTrackingManagerBase {
  /// {@macro sentry_tracking_manager}
  SentryTrackingManager(this.sentryDsn)
      : _sentry = Completer()
          ..complete(
            SentryFlutter.init(
              (options) => options.dsn = sentryDsn,
            ),
          );

  /// The Sentry DSN.
  final String sentryDsn;

  final Completer<void> _sentry;

  @override
  Future<void> sendReportingData(LogMessage log) async {
    await _sentry.future;
    await Sentry.captureException(
        log.error,
        stackTrace: log.stackTrace,
      );
  }
}
