import 'dart:async';

import 'package:sizzle_starter/src/core/utils/logger/logger.dart';

/// {@template error_tracking_manager}
/// A class which is responsible for enabling error tracking.
/// {@endtemplate}
abstract interface class ErrorTrackingManager implements LogObserver {
  /// Handles the log message.
  ///
  /// This method is called when a log message is received.
  Future<void> report(LogMessage log);

  /// Returns `true` if automatic error reporting is enabled.
  bool get automaticReportingEnabled;

  /// Enables error tracking.
  ///
  /// This method enables automatic error log reporting.
  Future<void> enableReporting();

  /// Disables error tracking.
  ///
  /// This method disables automatic error log reporting.
  Future<void> disableReporting();
}

/// {@template error_tracking_manager_base}
/// A class that is responsible for managing Sentry error tracking.
/// {@endtemplate}
abstract base class ErrorTrackingManagerBase implements ErrorTrackingManager {
  /// {@macro error_tracking_manager_base}
  ErrorTrackingManagerBase();

  /// Returns `true` if automatic error reporting is enabled.
  @override
  bool get automaticReportingEnabled => _automaticReportingEnabled;
  var _automaticReportingEnabled = false;

  @override
  void onLog(LogMessage logMessage) {
    if (_automaticReportingEnabled && shouldReport(logMessage.error)) {
      report(logMessage);
    }
  }

  @override
  Future<void> enableReporting() async {
    _automaticReportingEnabled = true;
  }

  @override
  Future<void> disableReporting() async {
    _automaticReportingEnabled = false;
  }

  /// Returns `true` if the error should be reported.
  @pragma('vm:prefer-inline')
  bool shouldReport(Object? error) => true;
}
