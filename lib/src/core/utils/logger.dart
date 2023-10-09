import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart' as logging;

/// Logger instance
final Logger logger = LoggerLogging();

/// Typedef for the log formatter
typedef LogFormatter = String Function(LogMessage message, LogOptions options);

/// Possible levels of logging
enum LoggerLevel implements Comparable<LoggerLevel> {
  /// Error level
  error._(1000),

  /// Warning level
  warning._(800),

  /// Info level
  info._(600),

  /// Debug level
  debug._(400),

  /// Verbose level
  verbose._(200);

  const LoggerLevel._(this.value);

  /// Value of the level
  final int value;

  @override
  int compareTo(LoggerLevel other) => value.compareTo(other.value);

  @override
  String toString() => '$LoggerLevel($value)';
}

/// {@template log_options}
/// Options for the logger
/// {@endtemplate}
base class LogOptions {
  /// {@macro log_options}
  const LogOptions({
    this.showTime = true,
    this.showEmoji = true,
    this.logInRelease = false,
    this.level = LoggerLevel.info,
    this.formatter,
  });

  /// Log level
  final LoggerLevel level;

  /// Whether to show time
  final bool showTime;

  /// Whether to show emoji
  final bool showEmoji;

  /// Whether to log in release mode
  final bool logInRelease;

  /// Formatter for the log message
  final LogFormatter? formatter;
}

/// {@template log_message}
/// Log message
/// {@endtemplate}
base class LogMessage {
  /// {@macro log_message}
  const LogMessage({
    required this.message,
    required this.logLevel,
    this.error,
    this.stackTrace,
    this.time,
  });

  /// Log message
  final String message;

  /// Log Error
  final Object? error;

  /// Stack trace
  final StackTrace? stackTrace;

  /// Time of the log
  final DateTime? time;

  /// Log level
  final LoggerLevel logLevel;
}

/// Logger interface
abstract base class Logger {
  /// Logs the error to the console
  void error(String message, {Object? error, StackTrace? stackTrace});

  /// Logs the warning to the console
  void warning(String message);

  /// Logs the info to the console
  void info(String message);

  /// Logs the debug to the console
  void debug(String message);

  /// Logs the verbose to the console
  void verbose(String message);

  /// Set up the logger
  L runLogging<L>(
    L Function() fn, [
    LogOptions options = const LogOptions(),
  ]);

  /// Stream of logs
  Stream<LogMessage> get logs;

  /// Handy method to log zoneError
  void logZoneError(Object error, StackTrace stackTrace) {
    this.error('Top-level error: $error', stackTrace: stackTrace);
  }

  /// Handy method to log [FlutterError]
  void logFlutterError(FlutterErrorDetails details) {
    error(details.exceptionAsString(), stackTrace: details.stack);
  }

  /// Handy method to log [PlatformDispatcher] error
  bool logPlatformDispatcherError(Object error, StackTrace stackTrace) {
    this.error('PlatformDispatcherError', error: error, stackTrace: stackTrace);
    return true;
  }
}

/// Default logger using logging package
final class LoggerLogging extends Logger {
  final _logger = logging.Logger('SizzleLogger');

  @override
  void debug(String message) => _logger.fine(message);

  @override
  void error(String message, {Object? error, StackTrace? stackTrace}) =>
      _logger.severe(message, error, stackTrace);

  @override
  void info(String message) => _logger.info(message);

  @override
  void verbose(String message) => _logger.finest(message);

  @override
  void warning(String message) => _logger.warning(message);

  @override
  Stream<LogMessage> get logs => _logger.onRecord.map(
        (record) => record.toLogMessage(),
      );

  @override
  L runLogging<L>(
    L Function() fn, [
    LogOptions options = const LogOptions(),
  ]) {
    if (kReleaseMode && !options.logInRelease) {
      return fn();
    }
    logging.hierarchicalLoggingEnabled = true;

    _logger.onRecord
        .where((event) => event.loggerName == 'SizzleLogger')
        .listen((event) {
      final logMessage = event.toLogMessage();
      final message = options.formatter?.call(
            logMessage,
            options,
          ) ??
          _formatLoggerMessage(
            log: logMessage,
            options: options,
          );

      if (logMessage.logLevel.compareTo(options.level) < 0) {
        return;
      }

      debugPrint(message);
    });

    return fn();
  }
}

String _formatLoggerMessage({
  required LogMessage log,
  required LogOptions options,
}) {
  final buffer = StringBuffer();
  if (options.showEmoji) {
    buffer.write(log.logLevel.emoji);
    buffer.write(' ');
  }
  if (options.showTime) {
    buffer.write(log.time?.formatTime());
    buffer.write(' | ');
  }
  buffer.write(log.message);
  if (log.error != null) {
    buffer.write(' | ');
    buffer.write(log.error);
  }
  if (log.stackTrace != null) {
    buffer.write(' | ');
    buffer.writeln(log.stackTrace);
  }

  return buffer.toString();
}

extension on DateTime {
  /// Transforms DateTime to String with format: 00:00:00
  String formatTime() =>
      [hour, minute, second].map((i) => i.toString().padLeft(2, '0')).join(':');
}

extension on logging.LogRecord {
  /// Transforms [logging.LogRecord] to [LogMessage]
  LogMessage toLogMessage() => LogMessage(
        message: message,
        error: error,
        stackTrace: stackTrace,
        time: time,
        logLevel: level.toLoggerLevel(),
      );
}

extension on logging.Level {
  /// Transforms [logging.Level] to [LoggerLevel]
  LoggerLevel toLoggerLevel() => switch (this) {
        logging.Level.SEVERE => LoggerLevel.error,
        logging.Level.WARNING => LoggerLevel.warning,
        logging.Level.INFO => LoggerLevel.info,
        logging.Level.FINE || logging.Level.FINER => LoggerLevel.debug,
        _ => LoggerLevel.verbose,
      };
}

extension on LoggerLevel {
  /// Transforms [LoggerLevel] to emoji
  String get emoji => switch (this) {
        LoggerLevel.error => '🔥',
        LoggerLevel.warning => '⚠️',
        LoggerLevel.info => '💡',
        LoggerLevel.debug => '🐛',
        LoggerLevel.verbose => '🔬',
      };
}
