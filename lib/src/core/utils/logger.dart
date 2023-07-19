import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart' as logging;

final AppLogger logger = AppLogger$Logging();

/// Possible levels of logging
enum LoggerLevel implements Comparable<LoggerLevel> {
  error._(1000),
  warning._(800),
  info._(600),
  debug._(400),
  verbose._(200);

  const LoggerLevel._(this.value);

  final int value;

  @override
  int compareTo(LoggerLevel other) => value.compareTo(other.value);

  @override
  String toString() => '$runtimeType($value)';
}

/// Logger options
base class LogOptions {
  const LogOptions({
    this.showTime = true,
    this.showEmoji = true,
    this.logInRelease = false,
    this.level = LoggerLevel.info,
    this.formatter,
  });

  final LoggerLevel level;

  final bool showTime;

  final bool showEmoji;

  final bool logInRelease;

  final String Function({
    required String message,
    required StackTrace? stackTrace,
    required DateTime? time,
  })? formatter;
}

/// Logger message
base class LogMessage {
  const LogMessage({
    required this.message,
    required this.logLevel,
    this.stackTrace,
    this.time,
  });

  final String message;

  final StackTrace? stackTrace;

  final DateTime? time;

  final LoggerLevel logLevel;
}

/// Logger interface
abstract interface class AppLogger {
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

final class AppLogger$Logging extends AppLogger {
  final logger = logging.Logger('SizzleLogger');

  @override
  void debug(Object message) => logger.fine(message);

  @override
  void error(
    Object message, {
    Object? error,
    StackTrace? stackTrace,
  }) =>
      logger.severe(
        message,
        error,
        stackTrace,
      );

  @override
  void info(Object message) => logger.info(message);

  @override
  Stream<LogMessage> get logs => logger.onRecord.map(
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

    logger.onRecord
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
      '${logLevel.emoji} ${time.formatTime()} | $message ${error != null ? '| $error' : ''}';

  @override
  void verbose(Object message) => logger.finest(message);

  @override
  void warning(Object message) => logger.warning(message);
}

extension on DateTime {
  /// Transforms DateTime to String with format: 00:00:00
  String formatTime() =>
      [hour, minute, second].map((i) => i.toString().padLeft(2)).join(':');
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
