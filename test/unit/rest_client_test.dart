import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:sizzle_starter/src/core/data/rest_client.dart';
import 'package:sizzle_starter/src/core/utils/exception/network_exception.dart';

void main() {
  group(
    'RestClient >',
    () {
      group('Build URI > ', () {
        late final Uri baseUri;
        setUpAll(
          () => baseUri = Uri.parse('https://example.com'),
        );
        test(
          'should build a valid URI with preceding slash',
          () {
            final uri = RestClient.buildUri(
              baseUri: baseUri,
              path: '/path',
            );
            expect(uri.toString(), 'https://example.com/path');
          },
        );
        test(
          'should build a valid URI without preceding slash',
          () {
            final uri = RestClient.buildUri(
              baseUri: baseUri,
              path: 'path',
            );
            expect(uri.toString(), 'https://example.com/path');
          },
        );
        test(
          'should build a valid URI with query parameters',
          () {
            final uri = RestClient.buildUri(
              baseUri: baseUri,
              path: 'path?pathkey=pathvalue',
              queryParams: {
                'key': 'value',
              },
            );
            expect(
              uri.toString(),
              'https://example.com/path?pathkey=pathvalue&key=value',
            );
          },
        );
      });
      group('Build request >', () {
        late final Uri baseUri;
        setUpAll(
          () => baseUri = Uri.parse('https://example.com'),
        );
        test(
          'should build a valid GET request',
          () {
            final request = RestClient.buildRequest(
              baseUri: baseUri,
              path: 'path',
              method: 'GET',
              headers: {
                'key': 'value',
              },
            );
            expect(request.method, 'GET');
            expect(request.url.toString(), 'https://example.com/path');
            expect(request.headers['key'], 'value');
          },
        );
        test(
          'should build a valid POST request',
          () {
            final request = RestClient.buildRequest(
              baseUri: baseUri,
              path: 'path',
              method: 'POST',
              headers: {
                'key': 'value',
              },
              body: {
                'bodykey': 'bodyvalue',
              },
            );
            expect(request.method, 'POST');
            expect(request.url.toString(), 'https://example.com/path');
            expect(request.headers['key'], 'value');
            expect(request.body, '{"bodykey":"bodyvalue"}');
          },
        );
        test(
          'should build a valid PUT request',
          () {
            final request = RestClient.buildRequest(
              baseUri: baseUri,
              path: 'path',
              method: 'PUT',
              headers: {
                'key': 'value',
              },
              body: {
                'bodykey': 'bodyvalue',
              },
            );
            expect(request.method, 'PUT');
            expect(request.url.toString(), 'https://example.com/path');
            expect(request.headers['key'], 'value');
            expect(request.body, '{"bodykey":"bodyvalue"}');
          },
        );
        test(
          'should build a valid DELETE request',
          () {
            final request = RestClient.buildRequest(
              baseUri: baseUri,
              path: 'path',
              method: 'DELETE',
              headers: {
                'key': 'value',
              },
            );
            expect(request.method, 'DELETE');
            expect(request.url.toString(), 'https://example.com/path');
            expect(request.headers['key'], 'value');
          },
        );
      });
      group('Decode response >', () {
        test(
          'Throw exception if response json is not in right format',
          () {
            final response = http.Response(
              '{"key":"value"}',
              200,
              headers: {
                'content-type': 'application/json',
              },
            );
            expect(
              () => RestClient.decodeResponse(response),
              throwsA(isA<InternalServerException>()),
              reason: 'Should throw an exception for an invalid JSON response',
            );
          },
        );
        test(
          'should throw an exception for an invalid JSON response',
          () {
            final response = http.Response(
              'invalid',
              200,
              headers: {
                'content-type': 'application/json',
              },
            );
            expect(
              () => RestClient.decodeResponse(response),
              throwsA(isA<InternalServerException>()),
            );
          },
        );
        test(
          'should throw an exception for an invalid content type',
          () {
            final response = http.Response(
              'invalid',
              200,
              headers: {
                'content-type': 'text/html',
              },
            );
            expect(
              () => RestClient.decodeResponse(response),
              throwsA(isA<InternalServerException>()),
            );
          },
        );
        test('Should decode error message correctly', () {
          final response = http.Response(
            '{"message": "error message"}',
            200,
            headers: {
              'content-type': 'application/json',
            },
          );
          expect(
            () => RestClient.decodeResponse(response),
            throwsA(isA<RestClientException>()),
          );
        });
        test('Should decode success data correctly', () {
          final response = http.Response(
            '{"data": {"key": "value"}}',
            200,
            headers: {
              'content-type': 'application/json',
            },
          );
          expect(
            () => RestClient.decodeResponse(response),
            returnsNormally,
          );
        });
      });
      group('Encode body >', () {
        test('should encode body correctly', () {
          final body = {
            'key': 'value',
          };
          final encodedBody = RestClient.encodeBody(body);
          expect(encodedBody, utf8.encode('{"key":"value"}'));
        });
      });
      group('Test HTTP methods >', () {
        group('GET >', () {
          late final http.Client client;
          late final RestClient restClient;
          setUpAll(() {
            client = MockClient(
              (request) async => http.Response(
                '{"data": {"key": "value"}}',
                200,
                headers: {
                  'content-type': 'application/json',
                },
              ),
            );
            restClient = RestClient(
              baseUrl: 'https://example.com',
              client: client,
            );
          });
          test('should call GET method correctly', () async {
            final response = await restClient.get(
              'path',
              headers: {
                'key': 'value',
              },
            );
            expect(response, isA<Map<String, dynamic>>());
          });

          test('should call GET method with query params correctly', () async {
            final response = await restClient.get(
              'path',
              headers: {
                'key': 'value',
              },
              queryParams: {
                'querykey': 'queryvalue',
              },
            );
            expect(response, isA<Map<String, dynamic>>());
          });

          test('should throw an exception for an invalid response', () async {
            final client = MockClient(
              (request) async => http.Response(
                'invalid',
                200,
                headers: {
                  'content-type': 'application/json',
                },
              ),
            );
            final restClient = RestClient(
              baseUrl: 'https://example.com',
              client: client,
            );
            expect(
              () => restClient.get('path'),
              throwsA(isA<RestClientException>()),
            );
          });

          test('should throw an exception for an invalid content type', () async {
            final client = MockClient(
              (request) async => http.Response(
                'invalid',
                200,
                headers: {
                  'content-type': 'text/html',
                },
              ),
            );
            final restClient = RestClient(
              baseUrl: 'https://example.com',
              client: client,
            );
            expect(
              () => restClient.get('path'),
              throwsA(isA<RestClientException>()),
            );
          });
        });
        group('POST >', () {
          late final http.Client client;
          late final RestClient restClient;
          setUpAll(() {
            client = MockClient(
              (request) async => http.Response(
                '{"data": {"key": "value"}}',
                200,
                headers: {
                  'content-type': 'application/json',
                },
              ),
            );
            restClient = RestClient(
              baseUrl: 'https://example.com',
              client: client,
            );
          });
          test('should call POST method correctly', () async {
            final response = await restClient.post(
              'path',
              headers: {
                'key': 'value',
              },
              body: {
                'bodykey': 'bodyvalue',
              },
            );
            expect(response, isA<Map<String, dynamic>>());
          });

          test('should throw an exception for an invalid response', () async {
            final client = MockClient(
              (request) async => http.Response(
                'invalid',
                200,
                headers: {
                  'content-type': 'application/json',
                },
              ),
            );
            final restClient = RestClient(
              baseUrl: 'https://example.com',
              client: client,
            );
            expect(
              () => restClient.post('path', body: {'key': 'value'}),
              throwsA(isA<RestClientException>()),
            );
          });

          test('should throw an exception for an invalid content type', () async {
            final client = MockClient(
              (request) async => http.Response(
                'invalid',
                200,
                headers: {
                  'content-type': 'text/html',
                },
              ),
            );
            final restClient = RestClient(
              baseUrl: 'https://example.com',
              client: client,
            );
            expect(
              () => restClient.post('path', body: {'key': 'value'}),
              throwsA(isA<RestClientException>()),
            );
          });
        });
      });
    },
  );
}
