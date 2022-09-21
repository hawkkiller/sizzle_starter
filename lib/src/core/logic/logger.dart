import 'package:flutter/material.dart';
import 'package:l/l.dart';
import 'package:stack_trace/stack_trace.dart';

extension on DateTime {
  String get formatted =>
      [hour, minute, second].map(Logger._timeFormat).join(':');
}

extension on LogLevel {
  String get emoji => maybeWhen(
        shout: () => '❗️',
        error: () => '🚫',
        warning: () => '⚠️',
        info: () => '💡',
        debug: () => '🐞',
        orElse: () => '',
      );
}

mixin Logger {
  static const _timeLength = 2;
  static const _logOptions = LogOptions(
    printColors: false,
    messageFormatting: _formatLoggerMessage,
  );

  static String _timeFormat(int input) =>
      input.toString().padLeft(_timeLength, '0');

  static String _formatLoggerMessage(
    Object message,
    LogLevel logLevel,
    DateTime now,
  ) =>
      '${logLevel.emoji} ${now.formatted} | $message';

  static String _formatError(
    String type,
    String error,
    StackTrace? stackTrace,
  ) {
    final trace = stackTrace ?? StackTrace.current;

    final buffer = StringBuffer(type)
      ..write(' error: ')
      ..writeln(error)
      ..writeln('Stack trace:')
      ..write(Trace.from(trace).terse);

    return buffer.toString();
  }

  static void logZoneError(
    Object? e,
    StackTrace s,
  ) {
    l.e(_formatError('Top-level', e.toString(), s), s);
  }

  static void logFlutterError(
    FlutterErrorDetails details,
  ) {
    final stack = details.stack;
    l.e(_formatError('Flutter', details.exceptionAsString(), stack), stack);
  }

  static T runLogging<T>(T Function() body) => l.capture(body, _logOptions);
}
