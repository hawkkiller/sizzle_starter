import 'dart:async';

import 'package:logging/logging.dart' as logging;
import 'package:pure/pure.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:sizzle_starter/src/core/utils/logger.dart';

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

/// A class which is responsible for managing error tracking.
class SentryTrackingManager implements ErrorTrackingManager {
  SentryTrackingManager({
    required String sentryDsn,
  }) : _sentryDsn = sentryDsn;

  final String _sentryDsn;

  Completer<StreamSubscription<void>?>? _subscriptionCompleter;

  /// Catch only warnings and errors
  static Stream<logging.LogRecord> get _warningsAndErrors =>
      logging.Logger.root.onRecord.where(_isWarningOrError);

  static bool _isWarningOrError(logging.LogRecord log) => switch (log) {
        logging.Level.WARNING => true,
        logging.Level.SEVERE => true,
        logging.Level.SHOUT => true,
        _ => false,
      };

  static Future<SentryId> _captureException(
    logging.LogRecord message,
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
      logger.warning(
        'Tried disabling error reporting when '
        'it was not enabled in the first place.',
      );
    } else {
      await subscription.cancel();
    }
  }
}
