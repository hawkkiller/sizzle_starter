import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:sizzle_starter/src/core/utils/logger.dart';

/// A class which is responsible for disabling error tracking.
abstract class ErrorTrackingDisabler {
  /// Disables error tracking.
  Future<void> disableReporting();
}

/// {@template error_tracking_manager}
/// A class which is responsible for enabling error tracking.
/// {@endtemplate}
abstract class ErrorTrackingManager implements ErrorTrackingDisabler {
  /// Enables error tracking.
  Future<void> enableReporting({required bool shouldSend});
}

/// {@template sentry_tracking_manager}
/// A class that is responsible for managing Sentry error tracking.
/// {@endtemplate}
class SentryTrackingManager implements ErrorTrackingManager {
  /// {@macro sentry_tracking_manager}
  SentryTrackingManager({
    required String sentryDsn,
  }) : _sentryDsn = sentryDsn;

  final String _sentryDsn;

  Completer<StreamSubscription<void>?>? _sentryCompleter;

  /// Catch only warnings and errors
  static Stream<LogMessage> get _warningsAndErrors =>
      logger.logs.where(_isWarningOrError);

  static bool _isWarningOrError(LogMessage log) => switch (log.logLevel) {
        LoggerLevel.error => true,
        LoggerLevel.warning => true,
        _ => false,
      };

  static Future<SentryId> _captureException(
    LogMessage log,
  ) =>
      Sentry.captureException(
        log.message,
        stackTrace: log.stackTrace,
      );

  Future<StreamSubscription<SentryId>?> _initSentry(
    bool shouldSend,
  ) async {
    if (_sentryDsn.isNotEmpty && shouldSend) {
      await SentryFlutter.init(
        (options) => options
          ..dsn = _sentryDsn
          ..tracesSampleRate = 1,
      );
      return _warningsAndErrors.asyncMap(_captureException).listen(null);
    } else {
      return null;
    }
  }

  @override
  Future<void> enableReporting({required bool shouldSend}) async {
    if (_sentryCompleter != null) {
      logger.warning(
        'Tried enabling error reporting when '
        'it was already enabled.',
      );
      await _sentryCompleter?.future;
      return SynchronousFuture(null);
    }

    _sentryCompleter = Completer<StreamSubscription<void>?>()
      ..complete(_initSentry(shouldSend));

    await _sentryCompleter?.future;
  }

  @override
  Future<void> disableReporting() async {
    if (_sentryCompleter == null) {
      logger.warning(
        'Tried disabling error reporting when '
        'it was not enabled',
      );
    } else {
      await (await _sentryCompleter?.future)?.cancel();
      _sentryCompleter = null;
    }
  }
}
