import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart' as logging;

/// Logger instance
final Logger logger = AppLogger$Logging();

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
  final String Function({
    required String message,
    required StackTrace? stackTrace,
    required DateTime? time,
  })? formatter;
}

/// {@template log_message}
/// Log message
/// {@endtemplate}
base class LogMessage {
  /// {@macro log_message}
  const LogMessage({
    required this.message,
    required this.logLevel,
    this.stackTrace,
    this.time,
  });

  /// Log message
  final String message;

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
  L runLogging<L>(
    L Function() fn, [
    LogOptions options = const LogOptions(),
  ]);

  /// Stream of logs
  Stream<LogMessage> get logs;

  /// Handy method to log zoneError
  void logZoneError(Object error, StackTrace stackTrace) {
    this.error('Top-level error', error: error, stackTrace: stackTrace);
  }

  /// Handy method to log [FlutterError]
  void logFlutterError(FlutterErrorDetails details) {
    error(details.exceptionAsString(), stackTrace: details.stack);
  }

  /// Handy method to log [PlatformDispatcher] error
  bool logPlatformDispatcherError(Object error, StackTrace stackTrace) {
    this.error(error, stackTrace: stackTrace);
    return true;
  }
}

/// Default logger using logging package
final class AppLogger$Logging extends Logger {
  final _logger = logging.Logger('SizzleLogger');

  @override
  void debug(Object message) => _logger.fine(message);

  @override
  void error(
    Object message, {
    Object? error,
    StackTrace? stackTrace,
  }) =>
      _logger.severe(
        message,
        error,
        stackTrace,
      );

  @override
  void info(Object message) => _logger.info(message);

  @override
  Stream<LogMessage> get logs => _logger.onRecord.map(
        (record) => LogMessage(
          message: record.message,
          stackTrace: record.stackTrace,
          time: record.time,
          logLevel: switch (record.level) {
            logging.Level.SEVERE => LoggerLevel.error,
            logging.Level.WARNING => LoggerLevel.warning,
            logging.Level.INFO => LoggerLevel.info,
            logging.Level.FINE || logging.Level.FINER => LoggerLevel.debug,
            _ => LoggerLevel.verbose,
          },
        ),
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
      final message = options.formatter?.call(
            message: event.message,
            stackTrace: event.stackTrace,
            time: event.time,
          ) ??
          _formatLoggerMessage(
            message: event.message,
            logLevel: event.level,
            time: event.time,
            error: event.error,
          );

      final logLevel = switch (event.level) {
        logging.Level.SEVERE => LoggerLevel.error,
        logging.Level.WARNING => LoggerLevel.warning,
        logging.Level.INFO => LoggerLevel.info,
        logging.Level.FINE || logging.Level.FINER => LoggerLevel.debug,
        _ => LoggerLevel.verbose,
      };

      if (logLevel.compareTo(options.level) < 0) {
        return;
      }

      debugPrint(message);
    });

    return fn();
  }

  /// Formats the logger message
  ///
  /// Combines emoji, time and message
  static String _formatLoggerMessage({
    required Object message,
    required logging.Level logLevel,
    required DateTime time,
    Object? error,
  }) =>
      '${logLevel.emoji} ${time.formatTime()}'
      ' | $message ${error != null ? '| $error' : ''}';

  @override
  void verbose(Object message) => _logger.finest(message);

  @override
  void warning(Object message) => _logger.warning(message);
}

extension on DateTime {
  /// Transforms DateTime to String with format: 00:00:00
  String formatTime() =>
      [hour, minute, second].map((i) => i.toString().padLeft(2, '0')).join(':');
}

extension on logging.Level {
  /// Emoji for each log level
  String get emoji => switch (this) {
        logging.Level.SHOUT => '❗️',
        logging.Level.SEVERE => '🚫',
        logging.Level.WARNING => '⚠️',
        logging.Level.INFO => '💡',
        logging.Level.CONFIG => '🐞',
        logging.Level.FINE => '📌',
        logging.Level.FINER => '📌📌',
        logging.Level.FINEST => '📌📌📌',
        logging.Level.ALL => '',
        _ => '',
      };
}
