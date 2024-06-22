import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart' as http_testing;
import 'package:sizzle_starter/src/core/rest_client/rest_client.dart';

void main() {
  group('RestClientHttp', () {
    test('returns normally', () {
      final mockClient = http_testing.MockClient(
        (request) async => http.Response('{"data": {"hello": "world"}}', 200),
      );

      final restClient = RestClientHttp(
        baseUrl: 'https://example.com',
        client: mockClient,
      );

      expectLater(
        restClient.send(path: '/', method: 'GET'),
        completion(
          isA<Map<String, Object?>>().having(
            (json) => json['hello'],
            'Data contains hello',
            'world',
          ),
        ),
      );
    });

    test("adds body if it's not null", () async {
      final mockClient = http_testing.MockClient((request) async {
        expect(
          request.body,
          '{"hello":"world"}',
          reason: 'Body should be {"hello":"world"}',
        );

        return http.Response('{"data": {"hello": "world"}}', 200);
      });

      final restClient = RestClientHttp(
        baseUrl: 'https://example.com',
        client: mockClient,
      );

      await expectLater(
        restClient.send(path: '/', method: 'POST', body: {'hello': 'world'}),
        completion(
          isA<Map<String, Object?>>().having(
            (json) => json['hello'],
            'Data contains hello',
            'world',
          ),
        ),
      );
    });

    test('adds headers', () {
      final mockClient = http_testing.MockClient((request) async {
        expect(request.headers['hello'], 'world');
        return http.Response('{"data": {"hello": "world"}}', 200);
      });

      final restClient = RestClientHttp(
        baseUrl: 'https://example.com',
        client: mockClient,
      );

      expectLater(
        restClient.send(
          path: '/',
          method: 'GET',
          headers: {'hello': 'world'},
        ),
        completion(
          isA<Map<String, Object?>>().having(
            (json) => json['hello'],
            'Data contains hello',
            'world',
          ),
        ),
      );
    });

    test('throws RestClientException on error', () {
      final mockClient = http_testing.MockClient(
        (request) async => http.Response('{"error": {}}', 400),
      );

      final restClient = RestClientHttp(
        baseUrl: 'https://example.com',
        client: mockClient,
      );

      expectLater(
        restClient.send(path: '/', method: 'GET'),
        throwsA(isA<StructuredBackendException>()),
      );
    });
  });
}
