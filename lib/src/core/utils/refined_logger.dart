import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart' as logging;

/// A logger used to log errors in the root zone.
final logger = LoggingLogger();

/// Defines the format of a log message.
///
/// This is a function type that takes a [LogMessage] and
/// [LoggingOptions] and returns a formatted string.
typedef LogFormatter = String Function(
  LogMessage message,
  LoggingOptions options,
);

/// Configuration options for logging behavior.
///
/// Allows customization of how log messages are formatted and displayed.
class LoggingOptions {
  /// Constructs an instance of [LoggingOptions].
  ///
  /// - [showTime]: Whether to include the timestamp in the log message.
  ///   Defaults to `true`.
  /// - [showEmoji]: Whether to include an emoji representing the log level.
  ///   Defaults to `true`.
  /// - [logInRelease]: Whether logging is enabled in release builds.
  ///   Defaults to `false`.
  /// - [level]: The minimum log level that will be displayed.
  ///   Defaults to [LogLevel.info].
  /// - [chunkSize]: The maximum size of a log message chunk. Defaults to 1024.
  /// - [coloredOutput]: Whether to use colored text for the console output.
  ///   Defaults to `false`.
  /// - [formatter]: An optional custom formatter for log messages.
  ///   If not provided, a default formatter is used.
  const LoggingOptions({
    this.showTime = true,
    this.showEmoji = true,
    this.logInRelease = false,
    this.level = LogLevel.info,
    this.chunkSize = 1024,
    this.coloredOutput = false,
    this.formatter,
  });

  /// Whether to include the timestamp in the log message.
  final bool showTime;

  /// Whether to include an emoji representing the log level in the log message.
  final bool showEmoji;

  /// Whether logging is enabled in release builds.
  final bool logInRelease;

  /// The minimum log level that will be displayed.
  final LogLevel level;

  /// The maximum size of a log message chunk, in bytes.
  final int chunkSize;

  /// Whether to use colored text for the console output.
  final bool coloredOutput;

  /// An optional custom formatter for log messages.
  ///
  /// If not provided, a default formatter is used.
  final LogFormatter? formatter;
}

/// Logger that uses the `logging` package to log messages
class LoggingLogger extends RefinedLogger {
  /// Constructs an instance of [LoggingLogger].
  LoggingLogger({
    LogLevel level = LogLevel.debug,
    String name = 'LoggingLogger',
    LoggingOptions options = const LoggingOptions(),
  }) : _logger = logging.Logger(name) {
    logging.hierarchicalLoggingEnabled = true;
    _logger.level = _recordLevelFromLogLevel(level);
    logs.listen((l) => _printLogMessage(l, options));
  }

  final logging.Logger _logger;

  void _printLogMessage(LogMessage message, LoggingOptions options) {
    final formattedMessage = options.formatter != null
        ? options.formatter!(message, options)
        : _defaultFormatter(message, options);

    Zone.current.print(formattedMessage);
  }

  String _defaultFormatter(LogMessage message, LoggingOptions options) {
    final time = options.showTime ? message.timestamp.toIso8601String() : '';
    final emoji = options.showEmoji ? message.level.emoji : '';
    final level = message.level;
    final colorCode = message.level.colorCode;
    final content = message.message;

    final buffer = StringBuffer();

    if (options.coloredOutput) {
      buffer.write('\x1B[$colorCode');
    }

    buffer.write('$emoji $time [$level] $content');

    if (message.error != null) {
      buffer.writeln();
      buffer.write(message.error);
    }

    if (message.stackTrace != null) {
      buffer.writeln();
      buffer.write(message.stackTrace);
    }

    if (buffer.length > options.chunkSize) {
      _logWithChunks(buffer.toString(), options.chunkSize);
    } else {
      _log(buffer.toString());
    }

    if (options.coloredOutput) {
      buffer.write('\x1B[0m');
    }

    return buffer.toString();
  }

  void _logWithChunks(String message, int chunkSize) {
    for (var start = 0; start < message.length; start += chunkSize) {
      final end = (start + chunkSize) < message.length
          ? (start + chunkSize)
          : message.length;
      final chunkMessage = message.substring(start, end);
      _log(chunkMessage);
    }
  }

  /// Logs a chunk of message
  void _log(String message) {
    Zone.current.print(message);
  }

  @override
  Stream<LogMessage> get logs => _logger.onRecord.map(
        _recordToLogMessage,
      );

  @override
  void destroy() {
    _logger.clearListeners();
  }

  @override
  void log(
    String message, {
    required LogLevel level,
    Object? error,
    StackTrace? stackTrace,
    Map<String, Object?>? context,
  }) {
    final recordLevel = _recordLevelFromLogLevel(level);
    _logger.log(
      recordLevel,
      message,
      error,
      stackTrace,
    );
  }

  LogMessage _recordToLogMessage(logging.LogRecord record) => LogMessage(
        message: record.message,
        level: _logLevelFromRecordLevel(record.level),
        timestamp: record.time,
        error: record.error,
        stackTrace: record.stackTrace,
      );

  logging.Level _recordLevelFromLogLevel(LogLevel level) {
    if (level == LogLevel.trace) {
      return logging.Level.FINEST;
    } else if (level == LogLevel.debug) {
      return logging.Level.FINE;
    } else if (level == LogLevel.info) {
      return logging.Level.INFO;
    } else if (level == LogLevel.warn) {
      return logging.Level.WARNING;
    } else if (level == LogLevel.error) {
      return logging.Level.SEVERE;
    } else if (level == LogLevel.fatal) {
      return logging.Level.SHOUT;
    } else {
      return logging.Level.FINE;
    }
  }

  LogLevel _logLevelFromRecordLevel(logging.Level level) {
    if (level == logging.Level.ALL) {
      return LogLevel.trace;
    } else if (level == logging.Level.FINEST) {
      return LogLevel.trace;
    } else if (level == logging.Level.FINER) {
      return LogLevel.debug;
    } else if (level == logging.Level.FINE) {
      return LogLevel.debug;
    } else if (level == logging.Level.CONFIG) {
      return LogLevel.info;
    } else if (level == logging.Level.INFO) {
      return LogLevel.info;
    } else if (level == logging.Level.WARNING) {
      return LogLevel.warn;
    } else if (level == logging.Level.SEVERE) {
      return LogLevel.error;
    } else if (level == logging.Level.SHOUT) {
      return LogLevel.fatal;
    } else {
      return LogLevel.debug;
    }
  }
}

/// Logger class, that manages the logging of messages
abstract class RefinedLogger {
  /// Stream of log messages
  Stream<LogMessage> get logs;

  /// Destroys the logger and releases any resources
  void destroy();

  /// Logs a message with the specified [level].
  void log(
    String message, {
    required LogLevel level,
    Object? error,
    StackTrace? stackTrace,
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
      );

  /// Logs a platform dispatcher error with [LogLevel.error].
  bool logPlatformDispatcherError(Object error, StackTrace stackTrace) {
    log(
      'Platform dispatcher error',
      level: LogLevel.error,
      error: error,
      stackTrace: stackTrace,
    );
    return true;
  }

  /// Logs a message with [LogLevel.trace].
  void trace(
    String message, {
    Object? error,
    StackTrace? stackTrace,
  }) =>
      log(
        message,
        level: LogLevel.trace,
        error: error,
        stackTrace: stackTrace,
      );

  /// Logs a message with [LogLevel.debug].
  void debug(
    String message, {
    Object? error,
    StackTrace? stackTrace,
  }) =>
      log(
        message,
        level: LogLevel.debug,
        error: error,
        stackTrace: stackTrace,
      );

  /// Logs a message with [LogLevel.info].
  void info(
    String message, {
    Object? error,
    StackTrace? stackTrace,
  }) =>
      log(
        message,
        level: LogLevel.info,
        error: error,
        stackTrace: stackTrace,
      );

  /// Logs a message with [LogLevel.warn].
  void warn(
    String message, {
    Object? error,
    StackTrace? stackTrace,
  }) =>
      log(
        message,
        level: LogLevel.warn,
        error: error,
        stackTrace: stackTrace,
      );

  /// Logs a message with [LogLevel.error].
  void error(
    String message, {
    Object? error,
    StackTrace? stackTrace,
  }) =>
      log(
        message,
        level: LogLevel.error,
        error: error,
        stackTrace: stackTrace,
      );

  /// Logs a message with [LogLevel.fatal].
  void fatal(
    String message, {
    Object? error,
    StackTrace? stackTrace,
  }) =>
      log(
        message,
        level: LogLevel.fatal,
        error: error,
        stackTrace: stackTrace,
      );
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
}

/// Log level, that describes the severity of the log message
enum LogLevel implements Comparable<LogLevel> {
  /// A log level describing events showing step by step execution of your code
  /// that can be ignored during the standard operation,
  /// but may be useful during extended debugging sessions.
  trace._(0),

  /// A log level used for events considered to be useful during software
  /// debugging when more granular information is needed.
  debug._(1),

  /// An event happened, the event is purely informative
  /// and can be ignored during normal operations.
  info._(2),

  /// Unexpected behavior happened inside the application, but it is continuing
  /// its work and the key business features are operating as expected.
  warn._(3),

  /// One or more functionalities are not working,
  /// preventing some functionalities from working correctly.
  /// For example, a network request failed, a file is missing, etc.
  error._(4),

  /// One or more key business functionalities are not working
  /// and the whole system doesn’t fulfill the business functionalities.
  fatal._(5);

  const LogLevel._(this.severity);

  /// The integer value of the log level.
  final int severity;

  @override
  int compareTo(LogLevel other) => severity.compareTo(other.severity);
}

extension on LogLevel {
  /// Get emoji from the log level
  String get emoji => const {
        LogLevel.trace: '🔍',
        LogLevel.debug: '🐛',
        LogLevel.info: 'ℹ️',
        LogLevel.warn: '⚠️',
        LogLevel.error: '❌',
        LogLevel.fatal: '💥',
      }[this]!;

  /// Get color code from the log level
  String get colorCode => const {
        LogLevel.trace: '0;37m', // white
        LogLevel.debug: '0;36m', // cyan
        LogLevel.info: '0;32m', // green
        LogLevel.warn: '0;33m', // yellow
        LogLevel.error: '0;31m', // red
        LogLevel.fatal: '0;35m', // magenta
      }[this]!;
}
