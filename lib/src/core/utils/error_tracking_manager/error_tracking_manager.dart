import 'dart:async';

import 'package:meta/meta.dart';
import 'package:sizzle_starter/src/core/utils/logger.dart';

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

  final Logger _logger;
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
