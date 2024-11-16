import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:sizzle_starter/src/core/rest_client/rest_client.dart';

final jsonUtf8 = const JsonCodec().fuse(utf8);

void main() {
  group('RestClientBase', () {
    test('encodeBodyWithValidMap', () {
      final body = {'key1': 'value1', 'key2': 2, 'key3': true};
      final encodedBody = RestClientBase.encodeBody(body);
      final expectedBody = jsonUtf8.encode(body);
      expect(encodedBody, equals(expectedBody));
    });

    test('encodeBodyWithEmptyMap', () {
      final body = <String, Object?>{};
      final encodedBody = RestClientBase.encodeBody(body);
      const expectedBody = [123, 125];
      expect(encodedBody, equals(expectedBody));
    });

    test('encodeBodyWithInvalidMap', () {
      final body = {'key1': const _NoOpClass()};
      expect(() => RestClientBase.encodeBody(body), throwsA(isA<ClientException>()));
    });

    test('encodeBodyWithNestedMap', () {
      final body = {
        'key1': 'value1',
        'key2': 2,
        'key3': true,
        'key4': {'key5': 'value5'},
      };
      final encodedBody = RestClientBase.encodeBody(body);
      final expectedBody = jsonUtf8.encode(body);
      expect(encodedBody, equals(expectedBody));
    });

    test('encodeBodyWithNestedLists', () {
      final body = {
        'key1': 'value1',
        'key2': 2,
        'key3': true,
        'key4': ['value5'],
      };
      final encodedBody = RestClientBase.encodeBody(body);
      final expectedBody = jsonUtf8.encode(body);
      expect(encodedBody, equals(expectedBody));
    });

    test('decodeResponseWithEmptyBody', () {
      expectLater(
        RestClientBase.decodeResponse(const BytesResponseBody(<int>[]), statusCode: 200),
        completion(isNull),
      );
    });

    test('decodeResponseWithMapBody', () {
      final body = {'key1': 'value1', 'key2': 2, 'key3': true};
      final encodedBody = jsonUtf8.encode(body);

      expectLater(
        RestClientBase.decodeResponse(BytesResponseBody(encodedBody), statusCode: 200),
        completion(equals(body)),
      );
    });

    test('decodeResponseWithStringBody', () {
      const body = '{}';
      final encodedBody = utf8.encode(body);
      expectLater(
        RestClientBase.decodeResponse(BytesResponseBody(encodedBody), statusCode: 200),
        completion(equals({})),
      );
    });

    test('decodeResponseWithEmptyStringBody', () {
      const body = '';
      final encodedBody = utf8.encode(body);
      expectLater(
        RestClientBase.decodeResponse(BytesResponseBody(encodedBody), statusCode: 200),
        completion(equals(null)),
      );
    });

    test('decodeResponseWithInvalidJsonBody', () {
      const body = 'invalid json';
      final encodedBody = utf8.encode(body);
      expectLater(
        RestClientBase.decodeResponse(BytesResponseBody(encodedBody), statusCode: 200),
        throwsA(isA<ClientException>()),
      );
    });

    test('decodeResponseWithInvalidJson', () {
      const body = 'invalid json';
      final encodedBody = utf8.encode(body);
      expectLater(
        RestClientBase.decodeResponse(BytesResponseBody(encodedBody), statusCode: 200),
        throwsA(isA<ClientException>()),
      );
    });

    test('decodeResponseWithErrorInResponseBody', () {
      final body = {
        'error': {'message': 'Some error message', 'code': 123},
      };
      final encodedBody = jsonUtf8.encode(body);
      expectLater(
        RestClientBase.decodeResponse(BytesResponseBody(encodedBody), statusCode: 400),
        throwsA(isA<StructuredBackendException>()),
      );
    });

    test('decodeResponseWithDataInResponseBody', () {
      final body = {
        'data': {'key1': 'value1', 'key2': 2, 'key3': true},
      };
      final encodedBody = jsonUtf8.encode(body);
      expectLater(
        RestClientBase.decodeResponse(BytesResponseBody(encodedBody), statusCode: 200),
        completion(equals(body['data'])),
      );
    });

    test('buildUriWithValidPathAndQueryParams', () {
      const path = '/path';
      final queryParams = {'key1': 'value1', 'key2': 'value2'};
      final uri = RestClientBase.buildUri(
        baseUrl: Uri.parse('http://localhost:8080'),
        path: path,
        queryParams: queryParams,
      );
      final expectedUri = Uri.parse('http://localhost:8080$path?key1=value1&key2=value2');
      expect(uri, equals(expectedUri));
    });

    test('buildUriWithEmptyPath', () {
      const path = '';
      final queryParams = {'key1': 'value1', 'key2': 'value2'};
      final uri = RestClientBase.buildUri(
        baseUrl: Uri.parse('http://localhost:8080'),
        path: path,
        queryParams: queryParams,
      );
      final expectedUri = Uri.parse(
        'http://localhost:8080?key1=value1&key2=value2',
      );
      expect(uri, equals(expectedUri));
    });

    test('buildUriWithSpecialCharactersInPath', () {
      const path = '/path with spaces';
      final queryParams = {'key1': 'value1', 'key2': 'value2'};
      final uri = RestClientBase.buildUri(
        baseUrl: Uri.parse('http://localhost:8080'),
        path: path,
        queryParams: queryParams,
      );
      final expectedUri = Uri.parse(
        'http://localhost:8080/path%20with%20spaces?key1=value1&key2=value2',
      );
      expect(uri, equals(expectedUri));
    });

    test('buildUriWithEndingSlashInBaseUrl', () {
      const path = '/path';
      final queryParams = {'key1': 'value1', 'key2': 'value2'};
      final uri = RestClientBase.buildUri(
        baseUrl: Uri.parse('http://localhost:8080/'),
        path: path,
        queryParams: queryParams,
      );
      final expectedUri = Uri.parse(
        'http://localhost:8080$path?key1=value1&key2=value2',
      );
      expect(uri, equals(expectedUri));
    });

    test('buildUriWithPathWithoutSlash', () {
      const path = 'path';
      final queryParams = {'key1': 'value1', 'key2': 'value2'};
      final uri = RestClientBase.buildUri(
        baseUrl: Uri.parse('http://localhost:8080'),
        path: path,
        queryParams: queryParams,
      );
      final expectedUri = Uri.parse(
        'http://localhost:8080/$path?key1=value1&key2=value2',
      );
      expect(uri, equals(expectedUri));
    });

    test('getReturns', () {
      const client = _ReturningRestClientBase();
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
      const client = _ReturningRestClientBase();
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
      const client = _ReturningRestClientBase();
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
      const client = _ReturningRestClientBase();
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
      const client = _ReturningRestClientBase();
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
      const client = _ReturningRestClientBase();
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
  const _ReturningRestClientBase();

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

  @override
  Future<Map<String, Object?>?> multipartPost({
    required String path,
    required String method,
    required List<MultipartFile> files,
    Map<String, String>? headers,
    Map<String, String?>? queryParams,
    Map<String, String>? fields,
  }) async =>
      {
        'path': path,
        'method': method,
        'files': files,
        'headers': headers,
        'queryParams': queryParams,
        'fields': fields,
      };
}

/// A no-op implementation of [RestClientBase].
///
/// This is used in tests to verify behaviour of basic methods
/// like encoding and decoding of request and response.
final class NoOpRestClientBase extends RestClientBase {
  const NoOpRestClientBase();

  @override
  Future<Map<String, Object?>?> send({
    required String path,
    required String method,
    Map<String, Object?>? body,
    Map<String, Object?>? headers,
    Map<String, Object?>? queryParams,
  }) =>
      throw UnimplementedError();

  @override
  Future<Map<String, Object?>?> multipartPost({
    required String path,
    required String method,
    required List<MultipartFile> files,
    Map<String, Object?>? headers,
    Map<String, Object?>? queryParams,
    Map<String, Object?>? fields,
  }) =>
      throw UnimplementedError();
}
