// Authored by Yakov K.
import 'dart:async';

import 'package:l/l.dart';
import 'package:pure/pure.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:stream_transform/stream_transform.dart';

/// A class which is responsible for managing error tracking.
abstract class ErrorTrackingDisabler {
  Future<void> disableReporting();
}

/// A class which is responsible for managing error tracking.
abstract class ErrorTrackingManager implements ErrorTrackingDisabler {
  Future<void> enableReporting({required bool shouldSend});
}

typedef _CompleteSubscription = void Function([
  StreamSubscription<void>? subscription,
]);

///
class SentryTrackingManager implements ErrorTrackingManager {
  SentryTrackingManager({
    required String sentryDsn,
  }) : _sentryDsn = sentryDsn;

  final String _sentryDsn;

  Completer<StreamSubscription<void>?>? _subscriptionCompleter;

  static Stream<LogMessageWithStackTrace> get _warningsAndErrors =>
      l.where(_isWarningOrError).whereType<LogMessageWithStackTrace>();

  static bool _true() => true;
  static bool _false() => false;

  static bool _isWarningOrError(LogMessage message) => message.level.maybeWhen(
        warning: _true,
        error: _true,
        orElse: _false,
      );

  static Future<SentryId> _captureException(
    LogMessageWithStackTrace message,
  ) =>
      Sentry.captureException(
        message.message,
        stackTrace: message.stackTrace,
      );

  Future<void> _onFirstCall(
    Future<void> Function(_CompleteSubscription complete) body,
  ) async {
    if (_subscriptionCompleter == null) {
      final completer = _subscriptionCompleter = Completer();
      try {
        await body(completer.complete);
      } on Object {
        completer.complete();
        rethrow;
      }
    } else {
      await _subscriptionCompleter?.future;
    }
  }

  Future<void> _initSentry(
    bool shouldSend,
    _CompleteSubscription complete,
  ) async {
    if (_sentryDsn.isNotEmpty && shouldSend) {
      await SentryFlutter.init(
        (options) => options
          ..dsn = _sentryDsn
          ..tracesSampleRate = 1,
      );
      complete(
        _warningsAndErrors.asyncMap(_captureException).listen(null.constant),
      );
    } else {
      complete();
    }
  }

  @override
  Future<void> enableReporting({required bool shouldSend}) => _onFirstCall(
        _initSentry.curry(shouldSend),
      );

  @override
  Future<void> disableReporting() async {
    final subscription = await _subscriptionCompleter?.future;
    if (subscription == null) {
      l.w(
        'Tried disabling error reporting when '
        'it was not enabled in the first place.',
      );
    } else {
      await subscription.cancel();
    }
  }
}
