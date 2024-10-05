import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart' as http_testing;
import 'package:sizzle_starter/src/core/utils/retry_request_mixin.dart';

void main() {
  group('Retry request mixin', () {
    late RetryRequestMixin retryRequestMixin;

    setUp(() {
      retryRequestMixin = const RetryRequestMixin();
    });

    test('retries base request', () async {
      await retryRequestMixin.retryRequest(
        http.StreamedResponse(
          Stream.fromIterable([]),
          request: http.Request('GET', Uri.parse('https://example.com')),
          200,
        ),
        http_testing.MockClient(
          (request) => Future.value(
            http.Response('response', 200, headers: {}),
          ),
        ),
      );
    });

    test('retries multipart request', () async {
      await retryRequestMixin.retryRequest(
        http.StreamedResponse(
          Stream.fromIterable([]),
          request: http.MultipartRequest(
            'GET',
            Uri.parse('https://example.com'),
          ),
          200,
        ),
        http_testing.MockClient(
          (request) => Future.value(
            http.Response('response', 200, headers: {}),
          ),
        ),
      );
    });

    test('throws on unsupported / not provided request', () {
      expect(
        () => retryRequestMixin.retryRequest(
          http.StreamedResponse(Stream.fromIterable([]), 200),
          http_testing.MockClient(
            (request) => Future.value(
              http.Response('response', 200, headers: {}),
            ),
          ),
        ),
        throwsA(isA<ArgumentError>()),
      );
    });
  });
}
