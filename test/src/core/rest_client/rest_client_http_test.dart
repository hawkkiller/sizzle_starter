import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart' as http_testing;
import 'package:sizzle_starter/src/core/rest_client/rest_client.dart';

void main() {
  group('RestClientHttp', () {
    test('returns normally', () {
      final mockClient = http_testing.MockClient(
        (request) async => http.Response('{"data": {}}', 200),
      );

      final restClient = RestClientHttp(
        baseUrl: 'https://example.com',
        client: mockClient,
      );

      expectLater(
        restClient.send(path: '/', method: 'GET'),
        completion(isNotNull),
      );
    });
  });
}
