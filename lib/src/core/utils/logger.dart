import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart' as logging;

/// Logger instance declared as global variable
///
/// Usage:
/// ```dart
/// logger.info('Hello World!');
/// ```
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
    this.chunkSize = 1024,
    this.coloredOutput = false,
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

  /// Size of each chunk for long messages
  final int chunkSize;

  /// Whether to show colored output
  final bool coloredOutput;
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
  final Object message;

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
  void error(Object message, {Object? error, StackTrace? stackTrace});

  /// Logs the warning to the console
  void warning(Object message);

  /// Logs the info to the console
  void info(Object message);

  /// Logs the debug to the console
  void debug(Object message);

  /// Logs the verbose to the console
  void verbose(Object message);

  /// Set up the logger
  L runLogging<L>(L Function() fn, [LogOptions options = const LogOptions()]);

  /// Stream of logs
  Stream<LogMessage> get logs;

  /// Handy method to log zoneError
  void logZoneError(Object error, StackTrace stackTrace) {
    this.error('Zone error: $error', error: error, stackTrace: stackTrace);
  }

  /// Handy method to log [FlutterError]
  void logFlutterError(FlutterErrorDetails details) {
    if (details.silent) {
      return;
    }

    final description = details.exceptionAsString();

    error(
      'Flutter Error: $description',
      error: details.exception,
      stackTrace: details.stack,
    );
  }

  /// Handy method to log [PlatformDispatcher] error
  bool logPlatformDispatcherError(Object error, StackTrace stackTrace) {
    this.error(
      'Platform Dispatcher Error: $error',
      error: error,
      stackTrace: stackTrace,
    );
    return true;
  }
}

/// Default logger using logging package
final class LoggerLogging extends Logger {
  final _logger = logging.Logger('SizzleLogger');

  @override
  void debug(Object message) => _logger.fine(message);

  @override
  void error(Object message, {Object? error, StackTrace? stackTrace}) =>
      _logger.severe(message, error, stackTrace);

  @override
  void info(Object message) => _logger.info(message);

  @override
  void verbose(Object message) => _logger.finest(message);

  @override
  void warning(Object message) => _logger.warning(message);

  @override
  Stream<LogMessage> get logs => _logger.onRecord.map(
        (record) => record.toLogMessage(),
      );

  @override
  L runLogging<L>(L Function() fn, [LogOptions options = const LogOptions()]) {
    if (kReleaseMode && !options.logInRelease) {
      return fn();
    }
    logging.hierarchicalLoggingEnabled = true;

    _logger.onRecord
        .where((event) => event.loggerName == 'SizzleLogger')
        .listen((event) {
      final logMessage = event.toLogMessage();
      final message = options.formatter?.call(logMessage, options) ??
          _formatLoggerMessage(log: logMessage, options: options);

      if (logMessage.logLevel.compareTo(options.level) < 0) {
        return;
      }

      if (message.length > options.chunkSize) {
        _logWithChunks(message, options.chunkSize);
      } else {
        Zone.current.print(message);
      }
    });

    return fn();
  }

  /// Logs the message in chunks if it exceeds the chunk size
  void _logWithChunks(String message, int chunkSize) {
    for (var start = 0; start < message.length; start += chunkSize) {
      final end = (start + chunkSize) < message.length
          ? (start + chunkSize)
          : message.length;
      final chunkMessage = message.substring(start, end);
      Zone.current.print(chunkMessage);
    }
  }
}

String _formatLoggerMessage({
  required LogMessage log,
  required LogOptions options,
}) {
  final buffer = StringBuffer();
  if (options.showEmoji) {
    buffer
      ..write(log.logLevel.emoji)
      ..write(' ');
  }
  if (options.showTime) {
    buffer
      ..write(log.time?.formatTime())
      ..write(' | ');
  }
  buffer.write(log.message);
  if (log.error != null) {
    buffer
      ..writeln()
      ..write(log.error);
  }
  if (log.stackTrace != null) {
    buffer
      ..writeln()
      ..write(log.stackTrace);
  }

  final logMessage = buffer.toString();
  return options.coloredOutput
      ? _applyColor(logMessage, log.logLevel)
      : logMessage;
}

String _applyColor(String message, LoggerLevel level) {
  const levelColors = <LoggerLevel, String>{
    LoggerLevel.error: '\x1B[31m', // Red
    LoggerLevel.warning: '\x1B[33m', // Yellow
    LoggerLevel.info: '\x1B[32m', // Green
    LoggerLevel.debug: '\x1B[34m', // Blue
    LoggerLevel.verbose: '\x1B[37m', // White
  };
  const resetColor = '\x1B[0m';
  return '${levelColors[level]}$message$resetColor';
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
