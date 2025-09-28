import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
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
      StackTrace? stack;

      if (logMessage.stackTrace case final stackTrace?) {
        stack = Trace.from(stackTrace).terse;
      }

      final builder = StringBuffer()
        ..write(DateFormat('MM-dd HH:mm:ss').format(logMessage.timestamp))
        ..write(' [${logMessage.level.toShortName()}]')
        ..write(' ${logMessage.message}');

      if (logMessage.error case final error?) {
        builder.write('\n$error');
      }

      if (stack != null) {
        builder.write('\n$stack');
      }

      debugPrint(builder.toString());
    }
  }
}
