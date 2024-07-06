import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:sizzle_starter/src/core/rest_client/rest_client.dart';

final jsonUtf8 = const JsonCodec().fuse(utf8);

void main() {
  group('RestClientBase', () {
    test('encodeBodyWithValidMap', () {
      final client = NoOpRestClientBase(baseUrl: 'http://localhost:8080');
      final body = {'key1': 'value1', 'key2': 2, 'key3': true};
      final encodedBody = client.encodeBody(body);
      final expectedBody = jsonUtf8.encode(body);
      expect(encodedBody, equals(expectedBody));
    });

    test('encodeBodyWithEmptyMap', () {
      final client = NoOpRestClientBase(baseUrl: 'http://localhost:8080');
      final body = <String, Object?>{};
      final encodedBody = client.encodeBody(body);
      const expectedBody = [123, 125];
      expect(encodedBody, equals(expectedBody));
    });

    test('encodeBodyWithInvalidMap', () {
      final client = NoOpRestClientBase(baseUrl: 'http://localhost:8080');
      final body = {'key1': const _NoOpClass()};
      expect(() => client.encodeBody(body), throwsA(isA<ClientException>()));
    });

    test('encodeBodyWithNestedMap', () {
      final client = NoOpRestClientBase(baseUrl: 'http://localhost:8080');
      final body = {
        'key1': 'value1',
        'key2': 2,
        'key3': true,
        'key4': {'key5': 'value5'},
      };
      final encodedBody = client.encodeBody(body);
      final expectedBody = jsonUtf8.encode(body);
      expect(encodedBody, equals(expectedBody));
    });

    test('encodeBodyWithNestedLists', () {
      final client = NoOpRestClientBase(baseUrl: 'http://localhost:8080');
      final body = {
        'key1': 'value1',
        'key2': 2,
        'key3': true,
        'key4': ['value5'],
      };
      final encodedBody = client.encodeBody(body);
      final expectedBody = jsonUtf8.encode(body);
      expect(encodedBody, equals(expectedBody));
    });

    test('decodeResponseWithNullBody', () {
      final client = NoOpRestClientBase(baseUrl: 'http://localhost:8080');
      expectLater(client.decodeResponse(null), completion(isNull));
    });

    test('decodeResponseWithEmptyBody', () {
      final client = NoOpRestClientBase(baseUrl: 'http://localhost:8080');
      expectLater(client.decodeResponse(<int>[]), completion(isNull));
    });

    test('decodeResponseWithMapBody', () {
      final client = NoOpRestClientBase(baseUrl: 'http://localhost:8080');
      final body = {'key1': 'value1', 'key2': 2, 'key3': true};
      final encodedBody = jsonUtf8.encode(body);
      expectLater(client.decodeResponse(encodedBody), completion(equals(body)));
    });

    test('decodeResponseWithStringBody', () {
      final client = NoOpRestClientBase(baseUrl: 'http://localhost:8080');
      const body = '{}';
      final encodedBody = utf8.encode(body);
      expectLater(client.decodeResponse(encodedBody), completion(equals({})));
    });

    test('decodeResponseWithEmptyStringBody', () {
      final client = NoOpRestClientBase(baseUrl: 'http://localhost:8080');
      const body = '';
      final encodedBody = utf8.encode(body);
      expectLater(client.decodeResponse(encodedBody), completion(equals(null)));
    });

    test('decodeResponseWithInvalidJsonBody', () {
      final client = NoOpRestClientBase(baseUrl: 'http://localhost:8080');
      const body = 'invalid json';
      final encodedBody = utf8.encode(body);
      expectLater(
        client.decodeResponse(encodedBody),
        throwsA(isA<ClientException>()),
      );
    });

    test('decodeResponseWithInvalidJson', () {
      final client = NoOpRestClientBase(baseUrl: 'http://localhost:8080');
      const body = 'invalid json';
      final encodedBody = utf8.encode(body);
      expectLater(
        client.decodeResponse(encodedBody),
        throwsA(isA<ClientException>()),
      );
    });

    test('decodeResponseWithErrorInResponseBody', () {
      final client = NoOpRestClientBase(baseUrl: 'http://localhost:8080');
      final body = {
        'error': {'message': 'Some error message', 'code': 123},
      };
      final encodedBody = jsonUtf8.encode(body);
      expectLater(
        client.decodeResponse(encodedBody),
        throwsA(isA<StructuredBackendException>()),
      );
    });

    test('decodeResponseWithDataInResponseBody', () {
      final client = NoOpRestClientBase(baseUrl: 'http://localhost:8080');
      final body = {
        'data': {'key1': 'value1', 'key2': 2, 'key3': true},
      };
      final encodedBody = jsonUtf8.encode(body);
      expectLater(
        client.decodeResponse(encodedBody),
        completion(equals(body['data'])),
      );
    });

    test('buildUriWithValidPathAndQueryParams', () {
      final client = NoOpRestClientBase(baseUrl: 'http://localhost:8080');
      const path = '/path';
      final queryParams = {'key1': 'value1', 'key2': 'value2'};
      final uri = client.buildUri(path: path, queryParams: queryParams);
      final expectedUri = Uri.parse('http://localhost:8080$path?key1=value1&key2=value2');
      expect(uri, equals(expectedUri));
    });

    test('buildUriWithEmptyPath', () {
      final client = NoOpRestClientBase(baseUrl: 'http://localhost:8080');
      const path = '';
      final queryParams = {'key1': 'value1', 'key2': 'value2'};
      final uri = client.buildUri(path: path, queryParams: queryParams);
      final expectedUri = Uri.parse(
        'http://localhost:8080?key1=value1&key2=value2',
      );
      expect(uri, equals(expectedUri));
    });

    test('buildUriWithSpecialCharactersInPath', () {
      final client = NoOpRestClientBase(baseUrl: 'http://localhost:8080');
      const path = '/path with spaces';
      final queryParams = {'key1': 'value1', 'key2': 'value2'};
      final uri = client.buildUri(path: path, queryParams: queryParams);
      final expectedUri = Uri.parse(
        'http://localhost:8080/path%20with%20spaces?key1=value1&key2=value2',
      );
      expect(uri, equals(expectedUri));
    });

    test('buildUriWithEndingSlashInBaseUrl', () {
      final client = NoOpRestClientBase(baseUrl: 'http://localhost:8080/');
      const path = '/path';
      final queryParams = {'key1': 'value1', 'key2': 'value2'};
      final uri = client.buildUri(path: path, queryParams: queryParams);
      final expectedUri = Uri.parse(
        'http://localhost:8080$path?key1=value1&key2=value2',
      );
      expect(uri, equals(expectedUri));
    });

    test('buildUriWithPathWithoutSlash', () {
      final client = NoOpRestClientBase(baseUrl: 'http://localhost:8080');
      const path = 'path';
      final queryParams = {'key1': 'value1', 'key2': 'value2'};
      final uri = client.buildUri(path: path, queryParams: queryParams);
      final expectedUri = Uri.parse(
        'http://localhost:8080/$path?key1=value1&key2=value2',
      );
      expect(uri, equals(expectedUri));
    });

    test('getReturns', () {
      final client = _ReturningRestClientBase(baseUrl: 'http://localhost:8080');
      expectLater(
        client.get('/path'),
        completion(
          equals({
            'path': '/path',
            'method': 'GET',
            'body': null,
            'headers': null,
            'queryParams': null,
          }),
        ),
      );
    });

    test('postReturns', () {
      final client = _ReturningRestClientBase(baseUrl: 'http://localhost:8080');
      expectLater(
        client.post('/path', body: {}),
        completion(
          equals({
            'path': '/path',
            'method': 'POST',
            'body': <String, Object?>{},
            'headers': null,
            'queryParams': null,
          }),
        ),
      );
    });

    test('putReturns', () {
      final client = _ReturningRestClientBase(baseUrl: 'http://localhost:8080');
      expectLater(
        client.put('/path', body: {}),
        completion(
          equals({
            'path': '/path',
            'method': 'PUT',
            'body': <String, Object?>{},
            'headers': null,
            'queryParams': null,
          }),
        ),
      );
    });

    test('deleteReturns', () {
      final client = _ReturningRestClientBase(baseUrl: 'http://localhost:8080');
      expectLater(
        client.delete('/path'),
        completion(
          equals({
            'path': '/path',
            'method': 'DELETE',
            'body': null,
            'headers': null,
            'queryParams': null,
          }),
        ),
      );
    });

    test('patchReturns', () {
      final client = _ReturningRestClientBase(baseUrl: 'http://localhost:8080');
      expectLater(
        client.patch('/path', body: {}),
        completion(
          equals({
            'path': '/path',
            'method': 'PATCH',
            'body': <String, Object?>{},
            'headers': null,
            'queryParams': null,
          }),
        ),
      );
    });

    test('sendReturns', () {
      final client = _ReturningRestClientBase(baseUrl: 'http://localhost:8080');
      expectLater(
        client.send(path: '/path', method: 'GET'),
        completion(
          equals({
            'path': '/path',
            'method': 'GET',
            'body': null,
            'headers': null,
            'queryParams': null,
          }),
        ),
      );
    });
  });
}

class _NoOpClass {
  const _NoOpClass();
}

final class _ReturningRestClientBase extends RestClientBase {
  _ReturningRestClientBase({required super.baseUrl});

  @override
  Future<Map<String, Object?>?> send({
    required String path,
    required String method,
    Map<String, Object?>? body,
    Map<String, Object?>? headers,
    Map<String, Object?>? queryParams,
  }) async =>
      {
        'path': path,
        'method': method,
        'body': body,
        'headers': headers,
        'queryParams': queryParams,
      };
}

/// A no-op implementation of [RestClientBase].
///
/// This is used in tests to verify behaviour of basic methods
/// like encoding and decoding of request and response.
final class NoOpRestClientBase extends RestClientBase {
  NoOpRestClientBase({required super.baseUrl});

  @override
  Future<Map<String, Object?>?> send({
    required String path,
    required String method,
    Map<String, Object?>? body,
    Map<String, Object?>? headers,
    Map<String, Object?>? queryParams,
  }) =>
      throw UnimplementedError();
}
