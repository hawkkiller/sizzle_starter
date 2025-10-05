import 'package:analytics/analytics.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:logger/logger.dart';

/// {@template firebase_analytics_reporter}
/// An implementation of [AnalyticsReporter] that reports events to Firebase
/// Analytics.
/// {@endtemplate}
final class FirebaseAnalyticsReporter implements AnalyticsReporter {
  /// {@macro firebase_analytics_reporter}
  const FirebaseAnalyticsReporter({required this.logger, required this.analytics});

  /// The logger used to log events locally for debugging.
  final Logger logger;

  /// The Firebase Analytics instance used to log events.
  final FirebaseAnalytics analytics;

  @override
  Future<void> logEvent(AnalyticsEvent event) async {
    logger.trace('Logging analytics event: $event');

    await analytics.logEvent(
      name: event.name,
      parameters: event.parameters.isEmpty
          ? null
          : {for (final parameter in event.parameters) parameter.name: parameter.value},
    );
  }
}
