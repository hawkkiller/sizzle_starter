import 'dart:async';

import 'package:clock/clock.dart';
import 'package:flutter/foundation.dart';
import 'package:stack_trace/stack_trace.dart';

/// Logger global instance.
///
/// This is the default logger used by the application.
/// Prefer to pass this logger instance as a parameter to the classes
/// that need it, instead of using it directly.
///
/// This is a zone-scoped logger, which means that it can be overridden
/// in nested zones or during tests.
RefinedLogger get logger => Zone.current[kLoggerKey] as RefinedLogger? ?? _logger;

/// Runs [callback] with the given [logger] instance.
///
/// This is [Zone]-scoped, so asynchronous callbacks spawned within [callback]
/// will also use the new value for [logger].
///
/// This is useful for testing purposes, where you can pass a mock logger
/// to the callback.
void runWithLogger<T>(RefinedLogger logger, T Function() callback) {
  runZoned(callback, zoneValues: {kLoggerKey: logger});
}

/// The key used to store the logger in the zone.
const kLoggerKey = 'logger';

/// A logger used to log errors in the root zone.
final _logger = DefaultLogger();

/// Defines the format of a log message.
///
/// This is a function type that takes a [LogMessage] and
/// [LoggingOptions] and returns a formatted string.
typedef LogFormatter = String Function(
  LogWrapper wrappedMessage,
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
    this.level = LogLevel.info,
    this.showTime = true,
    this.showEmoji = true,
    this.logInRelease = false,
    this.useDebugPrint = false,
    this.onMessageFormat,
  });

  /// Whether to include the timestamp in the log message.
  final bool showTime;

  /// Whether to include an emoji representing the log level in the log message.
  final bool showEmoji;

  /// Whether logging is enabled in release builds.
  final bool logInRelease;

  /// The minimum log level that will be displayed.
  final LogLevel level;

  /// Whether or not to chunk the log message.
  ///
  /// This is useful when the log message is too long.
  /// Use it with caution, as it affects the performance.
  /// Recommended for debugging purposes only.
  ///
  /// Uses [debugPrint] under the hood.
  final bool useDebugPrint;

  /// An optional custom formatter for log messages.
  ///
  /// If not provided, a default formatter is used.
  final LogFormatter? onMessageFormat;
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

/// Logger class, that manages the logging of messages
class DefaultLogger extends RefinedLogger {
  /// Constructs an instance of [DefaultLogger].
  DefaultLogger([LoggingOptions options = const LoggingOptions()]) {
    _init(options);
  }

  final _controller = StreamController<LogWrapper>();
  late final _logWrapStream = _controller.stream.asBroadcastStream();
  late final _logs = _logWrapStream.map((wrapper) => wrapper.message);
  StreamSubscription<LogWrapper>? _logSubscription;
  bool _destroyed = false;

  void _init(LoggingOptions options) {
    if (kReleaseMode && !options.logInRelease) {
      return;
    }

    _logSubscription = _logWrapStream.listen((l) => _printLogMessage(l, options));
  }

  @override
  Stream<LogMessage> get logs => _logs;

  @override
  void destroy() {
    _controller.close();
    _logSubscription?.cancel();
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
    if (_destroyed) {
      _log('Logger has been destroyed. It cannot be used anymore.');
      return;
    }

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

  void _printLogMessage(LogWrapper wrappedMessage, LoggingOptions options) {
    if (_destroyed) {
      _log('Logger has been destroyed. It cannot be used anymore.');
      return;
    }

    final formattedMessage = options.onMessageFormat != null
        ? options.onMessageFormat!(wrappedMessage, options)
        : _defaultFormatter(wrappedMessage, options);

    _log(formattedMessage);
  }

  String _defaultFormatter(LogWrapper wrappedMessage, LoggingOptions options) {
    final message = wrappedMessage.message;
    final time = options.showTime ? message.timestamp.toIso8601String() : '';
    final emoji = options.showEmoji ? message.level.emoji : '';
    final level = message.level;
    final content = message.message;
    final stackTrace = message.stackTrace;
    final error = message.error;

    final buffer = StringBuffer();

    buffer.write('$emoji $time [${level.name.toUpperCase()}] $content');

    if (error != null && wrappedMessage.printError) {
      buffer.writeln();
      buffer.write(error);
    }

    if (stackTrace != null && wrappedMessage.printStackTrace) {
      buffer.writeln();
      buffer.write(Trace.from(stackTrace).terse);
    }

    return buffer.toString();
  }

  /// Logs a chunk of message
  void _log(String message, {bool useDebugPrint = false}) {
    if (useDebugPrint) {
      debugPrint(message);
    } else {
      Zone.current.print(message);
    }
  }
}

/// {@macro logger}
///
/// A logger that does nothing.
class NoOpLogger extends RefinedLogger {
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
abstract class RefinedLogger {
  /// Constructs an instance of [RefinedLogger].
  const RefinedLogger();

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
}
