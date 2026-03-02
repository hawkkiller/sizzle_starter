import 'dart:async';

import 'package:common_logger/common_logger.dart';

/// {@template error_reporter}
/// An interface for reporting errors.
///
/// Implementations should report errors to a service like Sentry/Crashlytics.
/// {@endtemplate}
abstract interface class ErrorReporter {
  /// Capture an exception to be reported.
  ///
  /// The [throwable] is the exception that was thrown.
  /// The [stackTrace] is the stack trace associated with the exception.
  Future<void> captureException({required Object throwable, StackTrace? stackTrace});
}

/// {@template error_reporter_log_observer}
/// An observer that reports logs to the error reporter if it is active.
/// {@endtemplate}
final class ErrorReporterLogObserver with LogObserver {
  /// {@macro error_reporter_log_observer}
  const ErrorReporterLogObserver(this._errorReporter);

  /// Error reporter used to report errors.
  final ErrorReporter _errorReporter;

  @override
  void onLog(LogMessage logMessage) {
    if (logMessage.level.index >= LogLevel.error.index) {
      _errorReporter.captureException(
        throwable: logMessage.error ?? ReportedMessageException(logMessage.message),
        stackTrace: logMessage.stackTrace ?? StackTrace.current,
      );
    }
  }
}

/// An exception used for error logs without an exception, only a message.
class ReportedMessageException implements Exception {
  /// Constructs an instance of [ReportedMessageException].
  const ReportedMessageException(this.message);

  /// The message that was reported.
  final String message;

  @override
  String toString() => message;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ReportedMessageException && other.message == message;
  }

  @override
  int get hashCode => message.hashCode;
}
