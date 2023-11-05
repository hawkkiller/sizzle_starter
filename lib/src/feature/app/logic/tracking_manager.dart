import 'dart:async';

import 'package:meta/meta.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:sizzle_starter/src/core/utils/logger.dart';

/// A class which is responsible for disabling error tracking.
abstract class ExceptionTrackingDisabler {
  /// Disables error tracking.
  ///
  /// This method should be called when the user has opted out of error tracking
  Future<void> disableReporting();
}

/// {@template error_tracking_manager}
/// A class which is responsible for enabling error tracking.
/// {@endtemplate}
abstract interface class ExceptionTrackingManager
    implements ExceptionTrackingDisabler {
  /// Enables error tracking.
  ///
  /// This method should be called when the user has opted in to error tracking.
  Future<void> enableReporting();
}

/// {@template sentry_tracking_manager}
/// A class that is responsible for managing Sentry error tracking.
/// {@endtemplate}
abstract base class ExceptionTrackingManagerBase
    implements ExceptionTrackingManager {
  /// {@macro sentry_tracking_manager}
  ExceptionTrackingManagerBase(this._logger);

  final Logger _logger;
  StreamSubscription<LogMessage>? _subscription;

  /// Catch only warnings and errors
  Stream<LogMessage> get _reportLogs => _logger.logs.where(_isWarningOrError);

  static bool _isWarningOrError(LogMessage log) =>
      log.logLevel.value >= LoggerLevel.warning.value;

  @override
  @mustCallSuper
  @mustBeOverridden
  Future<void> disableReporting() async {
    await _subscription?.cancel();
    _subscription = null;
  }

  @override
  @mustCallSuper
  @mustBeOverridden
  Future<void> enableReporting() async {
    _subscription ??= _reportLogs.listen(_report);
  }

  /// Handles the log message.
  ///
  /// This method is called when a log message is received.
  Future<void> _report(LogMessage log);
}

/// {@template sentry_tracking_manager}
/// A class that is responsible for managing Sentry error tracking.
/// {@endtemplate}
final class SentryTrackingManager extends ExceptionTrackingManagerBase {
  /// {@macro sentry_tracking_manager}
  SentryTrackingManager(this.sentryDsn, super._logger);

  /// The Sentry DSN.
  final String sentryDsn;

  @override
  Future<void> _report(LogMessage log) async {
    final buffer = StringBuffer();
    buffer.write(log.message);
    if (log.error != null) {
      buffer.write('| ${log.error}');
    }
    await Sentry.captureException(
      buffer.toString(),
      stackTrace: log.stackTrace,
    );
  }

  @override
  Future<void> enableReporting() async {
    await Sentry.init((options) => options.dsn = sentryDsn);
    await super.enableReporting();
  }

  @override
  Future<void> disableReporting() async {
    await Sentry.close();
    await super.disableReporting();
  }
}
