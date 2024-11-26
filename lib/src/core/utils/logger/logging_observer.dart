import 'dart:developer' as dev;

import 'package:sizzle_starter/src/core/utils/logger/logger.dart';

/// {@template logging_observer}
/// An observer that logs messages to the console.
/// {@endtemplate}
final class LoggingObserver implements LogObserver {
  /// {@macro logging_observer}
  const LoggingObserver({required this.logLevel});

  /// The log level to observe.
  final LogLevel logLevel;

  @override
  void onLog(LogMessage logMessage) {
    if (logMessage.level.index >= logLevel.index) {
      final logLevelsLength = LogLevel.values.length;
      final severityPerLevel = 2000 ~/ logLevelsLength;
      final level = logMessage.level.index * severityPerLevel;

      dev.log(
        logMessage.message,
        time: logMessage.timestamp,
        error: logMessage.error,
        stackTrace: logMessage.stackTrace,
        level: level,
        name: logMessage.level.toShortName(),
      );
    }
  }
}
