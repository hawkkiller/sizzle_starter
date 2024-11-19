import 'dart:async';
import 'dart:developer' as developer;

import 'package:clock/clock.dart';
import 'package:flutter/foundation.dart';
import 'package:stack_trace/stack_trace.dart';

/// Configuration options for logging behavior.
///
/// Allows customization of how log messages are formatted and displayed.
class LoggingOptions {
  /// Constructs an instance of [LoggingOptions].
  ///
  /// - [logInRelease]: Whether logging is enabled in release builds.
  ///   Defaults to `false`.
  /// - [level]: The minimum log level that will be displayed.
  ///   Defaults to [LogLevel.info].
  const LoggingOptions({
    this.logInRelease = false,
    this.level = LogLevel.info,
  });

  /// Whether logging is enabled in release builds.
  final bool logInRelease;

  /// The minimum log level that will be displayed.
  final LogLevel level;
}

/// Internal class used by [DefaultLogger] to wrap the log messages.
class LogWrapper {
  /// Constructs an instance of [LogWrapper].
  LogWrapper({
    required this.message,
    required this.printStackTrace,
    required this.printError,
  });

  /// The log message to be wrapped.
  LogMessage message;

  /// Whether to print the stack trace.
  bool printStackTrace;

  /// Whether to print the error.
  bool printError;
}

/// {@template printing_logger}
/// A logger that uses [developer.log] to print log messages.
/// {@endtemplate}
base class DeveloperLogger extends DefaultLogger {
  /// Constructs an instance of [DeveloperLogger].
  DeveloperLogger([this.options = const LoggingOptions()]) {
    _subscription = _logWrapStream.listen((wrappedLog) {
      _printLogMessage(wrappedLog, options);
    });
  }

  /// The options used by this logger.
  final LoggingOptions options;

  /// The subscription to the log stream.
  StreamSubscription<LogWrapper>? _subscription;

  @override
  void destroy() {
    super.destroy();
    _subscription?.cancel();
  }

  void _printLogMessage(LogWrapper wrappedLog, LoggingOptions options) {
    if (wrappedLog.message.level.compareTo(options.level) < 0) return;

    final log = wrappedLog.message;

    final logLevelsLength = LogLevel.values.length;
    final severityPerLevel = 2000 ~/ logLevelsLength;
    final severity = log.level.index * severityPerLevel;

    developer.log(
      log.message,
      error: wrappedLog.printError ? log.error : null,
      // We have levels from 0 to 5, but developer.log has from 0 to 2000,
      // so we need to multiply by 400 to get a value between 0 and 2000.
      level: severity,
      name: log.level.toShortName(),
      stackTrace: wrappedLog.printStackTrace && log.stackTrace != null
          ? Trace.from(log.stackTrace!).terse
          : null,
      time: log.timestamp,
    );
  }
}

/// The default logger implementation, used by the application.
base class DefaultLogger extends Logger {
  /// Constructs an instance of [DefaultLogger].
  DefaultLogger();

  final _controller = StreamController<LogWrapper>();
  late final _logWrapStream = _controller.stream.asBroadcastStream();
  late final _logs = _logWrapStream.map((wrapper) => wrapper.message);
  bool _destroyed = false;

  @override
  Stream<LogMessage> get logs => _logs;

  @override
  void destroy() {
    _controller.close();
    _destroyed = true;
  }

  @override
  void log(
    String message, {
    required LogLevel level,
    Object? error,
    StackTrace? stackTrace,
    Map<String, Object?>? context,
    bool printStackTrace = true,
    bool printError = true,
  }) {
    assert(!_destroyed, 'Logger has been destroyed. It cannot be used anymore.');
    if (_destroyed) return;

    final logMessage = LogWrapper(
      message: LogMessage(
        message: message,
        level: level,
        timestamp: clock.now(),
        error: error,
        stackTrace: stackTrace,
        context: context,
      ),
      printStackTrace: printStackTrace,
      printError: printError,
    );

    _controller.add(logMessage);
  }
}

/// {@macro logger}
///
/// A logger that does nothing, used for testing purposes.
final class NoOpLogger extends Logger {
  /// Constructs an instance of [NoOpLogger].
  const NoOpLogger();

  @override
  // ignore: no-empty-block
  void destroy() {}

  @override
  void log(
    String message, {
    required LogLevel level,
    Object? error,
    StackTrace? stackTrace,
    Map<String, Object?>? context,
    bool printStackTrace = true,
    bool printError = true,
    // ignore: no-empty-block
  }) {}

  @override
  Stream<LogMessage> get logs => const Stream.empty();
}

/// {@template logger}
/// Logger class, that manages the logging of messages
/// {@endtemplate}
abstract base class Logger {
  /// Constructs an instance of [Logger].
  const Logger();

  /// Stream of log messages
  Stream<LogMessage> get logs;

  /// Destroys the logger and releases all resources
  ///
  /// After calling this method, the logger should not be used anymore.
  void destroy();

  /// Logs a message with the specified [level].
  void log(
    String message, {
    required LogLevel level,
    Object? error,
    StackTrace? stackTrace,
    Map<String, Object?>? context,
    bool printStackTrace = true,
    bool printError = true,
  });

  /// Logs a zone error with [LogLevel.error].
  void logZoneError(Object error, StackTrace stackTrace) => log(
        'Zone error',
        level: LogLevel.error,
        error: error,
        stackTrace: stackTrace,
      );

  /// Logs a flutter error with [LogLevel.error].
  void logFlutterError(FlutterErrorDetails details) => log(
        details.toString(),
        level: LogLevel.error,
        error: details.exception,
        stackTrace: details.stack,
        printStackTrace: false,
        printError: false,
      );

  /// Logs a platform dispatcher error with [LogLevel.error].
  bool logPlatformDispatcherError(Object error, StackTrace stackTrace) {
    log(
      'Platform Error',
      level: LogLevel.error,
      error: error,
      stackTrace: stackTrace,
    );

    return true;
  }

  /// Creates a logger that uses this instance with a new prefix.
  Logger withPrefix(String prefix) => PrefixedLogger(this, prefix);

  /// Logs a message with [LogLevel.trace].
  void trace(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    Map<String, Object?>? context,
    bool printStackTrace = true,
    bool printError = true,
  }) =>
      log(
        message,
        level: LogLevel.trace,
        error: error,
        stackTrace: stackTrace,
        context: context,
        printStackTrace: printStackTrace,
        printError: printError,
      );

  /// Logs a message with [LogLevel.debug].
  void debug(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    Map<String, Object?>? context,
    bool printStackTrace = true,
    bool printError = true,
  }) =>
      log(
        message,
        level: LogLevel.debug,
        error: error,
        stackTrace: stackTrace,
        context: context,
        printStackTrace: printStackTrace,
        printError: printError,
      );

  /// Logs a message with [LogLevel.info].
  void info(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    Map<String, Object?>? context,
    bool printStackTrace = true,
    bool printError = true,
  }) =>
      log(
        message,
        level: LogLevel.info,
        error: error,
        stackTrace: stackTrace,
        context: context,
        printStackTrace: printStackTrace,
        printError: printError,
      );

  /// Logs a message with [LogLevel.warn].
  void warn(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    Map<String, Object?>? context,
    bool printStackTrace = true,
    bool printError = true,
  }) =>
      log(
        message,
        level: LogLevel.warn,
        error: error,
        stackTrace: stackTrace,
        context: context,
        printStackTrace: printStackTrace,
        printError: printError,
      );

  /// Logs a message with [LogLevel.error].
  void error(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    Map<String, Object?>? context,
    bool printStackTrace = true,
    bool printError = true,
  }) =>
      log(
        message,
        level: LogLevel.error,
        error: error,
        stackTrace: stackTrace,
        context: context,
        printStackTrace: printStackTrace,
        printError: printError,
      );

  /// Logs a message with [LogLevel.fatal].
  void fatal(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    Map<String, Object?>? context,
    bool printStackTrace = true,
    bool printError = true,
  }) =>
      log(
        message,
        level: LogLevel.fatal,
        error: error,
        stackTrace: stackTrace,
        context: context,
        printStackTrace: printStackTrace,
        printError: printError,
      );
}

/// A logger that prefixes all log messages with a given string.
base class PrefixedLogger extends Logger {
  /// Constructs an instance of [PrefixedLogger].
  const PrefixedLogger(this._logger, this._prefix);

  final Logger _logger;
  final String _prefix;

  @override
  Stream<LogMessage> get logs => _logger.logs;

  @override
  void destroy() => _logger.destroy();

  @override
  Logger withPrefix(String prefix) => PrefixedLogger(_logger, '$_prefix $prefix');

  @override
  void log(
    String message, {
    required LogLevel level,
    Object? error,
    StackTrace? stackTrace,
    Map<String, Object?>? context,
    bool printStackTrace = true,
    bool printError = true,
  }) {
    _logger.log(
      '$_prefix $message',
      level: level,
      error: error,
      stackTrace: stackTrace,
      context: context,
      printStackTrace: printStackTrace,
      printError: printError,
    );
  }
}

/// Represents a single log message with various details
/// for debugging and information purposes.
class LogMessage {
  /// Constructs an instance of [LogMessage].
  ///
  /// - [message]: The main content of the log message.
  /// - [level]: The severity level of the log message,
  ///   represented by [LogLevel].
  /// - [timestamp]: The date and time when the log message was created.
  /// - [error]: Optional. Any error object associated with the log message.
  /// - [stackTrace]: Optional. The stack trace associated with the log message,
  ///   typically provided when logging errors.
  /// - [context]: Optional. Additional contextual information provided
  ///   as a map, which can be useful for debugging.
  const LogMessage({
    required this.message,
    required this.level,
    required this.timestamp,
    this.error,
    this.stackTrace,
    this.context,
  });

  /// The main content of the log message.
  final String message;

  /// The severity level of the log message.
  final LogLevel level;

  /// The date and time when the log message was created.
  final DateTime timestamp;

  /// Any error object associated with the log message.
  ///
  /// This is typically used when the log message is related
  /// to an exception or error condition.
  final Object? error;

  /// The stack trace associated with the log message.
  ///
  /// This provides detailed information about the call stack leading
  /// up to the log message, which is particularly useful when logging errors.
  final StackTrace? stackTrace;

  /// Additional contextual information provided as a map.
  final Map<String, Object?>? context;
}

/// Log level, that describes the severity of the log message
///
/// Index of the log level is used to determine the severity of the log message.
enum LogLevel implements Comparable<LogLevel> {
  /// A log level describing events showing step by step execution of your code
  /// that can be ignored during the standard operation,
  /// but may be useful during extended debugging sessions.
  trace._(),

  /// A log level used for events considered to be useful during software
  /// debugging when more granular information is needed.
  debug._(),

  /// An event happened, the event is purely informative
  /// and can be ignored during normal operations.
  info._(),

  /// Unexpected behavior happened inside the application, but it is continuing
  /// its work and the key business features are operating as expected.
  warn._(),

  /// One or more functionalities are not working,
  /// preventing some functionalities from working correctly.
  /// For example, a network request failed, a file is missing, etc.
  error._(),

  /// One or more key business functionalities are not working
  /// and the whole system doesn’t fulfill the business functionalities.
  fatal._();

  const LogLevel._();

  @override
  int compareTo(LogLevel other) => index - other.index;

  /// Return short name of the log level.
  String toShortName() => switch (this) {
        LogLevel.trace => 'TRC',
        LogLevel.debug => 'DBG',
        LogLevel.info => 'INF',
        LogLevel.warn => 'WRN',
        LogLevel.error => 'ERR',
        LogLevel.fatal => 'FTL',
      };
}
