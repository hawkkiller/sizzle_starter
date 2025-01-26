import 'dart:developer' as dev;

import 'package:sizzle_starter/src/core/utils/logger/logger.dart';
import 'package:stack_trace/stack_trace.dart';

/// {@template printing_log_observer}
/// [LogObserver] that prints logs using `dart:developer`.
/// {@endtemplate}
final class PrintingLogObserver with LogObserver {
  /// {@macro printing_log_observer}
  const PrintingLogObserver({required this.logLevel});

  /// The log level to observe.
  final LogLevel logLevel;

  @override
  void onLog(LogMessage logMessage) {
    if (logMessage.level.index >= logLevel.index) {
      final logLevelsLength = LogLevel.values.length;
      final severityPerLevel = 2000 ~/ logLevelsLength;
      final level = logMessage.level.index * severityPerLevel;

      StackTrace? stack;

      if (logMessage.stackTrace case final stackTrace?) {
        stack = Trace.from(stackTrace).terse;
      }

      dev.log(
        logMessage.message,
        time: logMessage.timestamp,
        error: logMessage.error,
        stackTrace: stack,
        level: level,
        name: logMessage.level.toShortName(),
      );
    }
  }
}
