import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import '../../../../packages/analytics/lib/src/analytics_reporter.dart';
import '../../../../packages/analytics/lib/src/firebase_analytics_reporter.dart';

@GenerateNiceMocks([MockSpec<FirebaseAnalytics>()])
import 'firebase_analytics_reporter_test.mocks.dart';

void main() {
  late FirebaseAnalyticsReporter reporter;
  late FirebaseAnalytics mockAnalytics;

  setUp(() {
    mockAnalytics = MockFirebaseAnalytics();
    reporter = FirebaseAnalyticsReporter(
      analytics: mockAnalytics,
      logger: Logger(),
    );
  });

  group('FirebaseAnalyticsReporter', () {
    test('logEvent logs event to Firebase Analytics', () async {
      const event = AnalyticsEvent('test_event');
      await reporter.logEvent(event);

      verify(mockAnalytics.logEvent(name: 'test_event')).called(1);
    });

    test('logEvent logs event with parameters', () async {
      final event = AnalyticsEvent(
        'test_event',
        parameters: {
          const StringAnalyticsParameter('test_parameter', 'test_value'),
          const StringAnalyticsParameter('test_parameter2', 'test_value2'),
        },
      );

      await reporter.logEvent(event);

      verify(
        mockAnalytics.logEvent(
          name: 'test_event',
          parameters: {'test_parameter': 'test_value', 'test_parameter2': 'test_value2'},
        ),
      ).called(1);
    });
  });
}
