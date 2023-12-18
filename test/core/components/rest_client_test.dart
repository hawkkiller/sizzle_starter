// ignore_for_file: no-empty-block

import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sizzle_starter/src/core/components/rest_client/rest_client.dart';
import 'package:sizzle_starter/src/core/components/rest_client/src/rest_client_dio.dart';
import 'auth_interceptor_test.dart' as auth_interceptor_test;

Map<String, Object?> _generateJsonData(int length) => {
      'data': {
        'list': List.generate(length, (index) => {'test': 'test'}),
      },
    };

void main() {
  group('RestClient >', () {
    auth_interceptor_test.main();

    group('encodeBody >', () {
      test('Should encode body', () {
        final restClient = _RestClientBase();
        final result = restClient.encodeBody({'test': 'test'});
        expect(
          result,
          equals([
            123,
            34,
            116,
            101,
            115,
            116,
            34,
            58,
            34,
            116,
            101,
            115,
            116,
            34,
            125,
          ]),
        );
      });
      test('Should encode empty body', () {
        final restClient = _RestClientBase();
        final result = restClient.encodeBody({});
        expect(result, equals([123, 125]));
      });

      test('Should throw error on wrong body', () {
        final restClient = _RestClientBase();
        expect(
          () => restClient.encodeBody({'wrong': Object()}),
          throwsA(isA<RestClientException>()),
        );
      });
    });
    group('decodeResponse >', () {
      test('Should decode String', () {
        final restClient = _RestClientBase();
        const response = '{"data": {"test": "test"}}';
        final result = restClient.decodeResponse(response);
        expect(result, completion(equals({'test': 'test'})));
      });

      test('Should decode List<int>', () {
        final restClient = _RestClientBase();
        const response = [123, 34, 100, 97, 116, 97, 34, 58, 123, 125, 125];
        final result = restClient.decodeResponse(response);
        expectLater(result, completion(equals({})));
      });

      test('Should decode Map<String, Object?>', () {
        final restClient = _RestClientBase();
        const response = {
          'data': {'test': 'test'},
        };
        final result = restClient.decodeResponse(response);
        expect(result, completion(equals({'test': 'test'})));
      });

      test('Should throw WrongResponseTypeException', () {
        final restClient = _RestClientBase();
        const response = 123;
        final result = restClient.decodeResponse(response);
        expect(result, throwsA(isA<WrongResponseTypeException>()));
      });

      test('Return null when no data', () {
        final restClient = _RestClientBase();
        const response = {'test': 'test'};
        final result = restClient.decodeResponse(response);
        expect(result, completion(isNull));
      });

      test('Return null when null response', () {
        final restClient = _RestClientBase();
        final result = restClient.decodeResponse(null);
        expect(result, completion(isNull));
      });

      test('Throw if error field in JSON', () {
        final restClient = _RestClientBase();
        const response = '{"error": {"message": "test"}}';
        final result = restClient.decodeResponse(response);
        expect(
          result,
          throwsA(
            predicate<RestClientException>((p) => p.message == 'test'),
          ),
        );
      });

      test('If length is > 10000, compute in Isolate', () {
        final data = _generateJsonData(10000);
        final bytes = utf8.encode(jsonEncode(data));

        final restClient = _RestClientBase();

        final result = restClient.decodeResponse(bytes);

        expect(result, completion(data['data']));
      });
    });

    group('RestClientDio >', () {
      test('Decodes and returns response for methods', () {
        final mockAdapter = MockHttpAdapter()
          ..registerResponse(
            '/test',
            (req) => ResponseBody.fromString('{"data": {"test": "test"}}', 200),
          );
        final restClient = RestClientDio(
          baseUrl: '',
          dio: Dio()..httpClientAdapter = mockAdapter,
        );
        expectLater(
          restClient.get('/test'),
          completion(equals({'test': 'test'})),
        );
        expectLater(
          restClient.post('/test', body: {}),
          completion(equals({'test': 'test'})),
        );
        expectLater(
          restClient.delete('/test'),
          completion(equals({'test': 'test'})),
        );
        expectLater(
          restClient.patch('/test', body: {}),
          completion(equals({'test': 'test'})),
        );
        expectLater(
          restClient.put('/test', body: {}),
          completion(equals({'test': 'test'})),
        );
      });

      test('Throws RestClientException for methods', () {
        final mockAdapter = MockHttpAdapter()
          ..registerResponse(
            '/test',
            (req) => ResponseBody.fromString(
              '{"error": {"message": "test"}}',
              400,
            ),
          );

        final restClient = RestClientDio(
          baseUrl: '',
          dio: Dio()..httpClientAdapter = mockAdapter,
        );
        expectLater(
          restClient.get('/test'),
          throwsA(
            predicate<RestClientException>((p) => p.message == 'test'),
          ),
        );
        expectLater(
          restClient.post('/test', body: {}),
          throwsA(
            predicate<RestClientException>((p) => p.message == 'test'),
          ),
        );
        expectLater(
          restClient.delete('/test'),
          throwsA(
            predicate<RestClientException>((p) => p.message == 'test'),
          ),
        );
        expectLater(
          restClient.patch('/test', body: {}),
          throwsA(
            predicate<RestClientException>((p) => p.message == 'test'),
          ),
        );
        expectLater(
          restClient.put('/test', body: {}),
          throwsA(
            predicate<RestClientException>((p) => p.message == 'test'),
          ),
        );
      });

      test('Throws ConnectionException for methods', () {
        final mockAdapter = MockHttpAdapter()
          ..registerResponse(
            '/test',
            (req) => throw DioException.connectionError(
              requestOptions: req,
              reason: 'No Internet!',
            ),
          );
        final restClient = RestClientDio(
          baseUrl: '',
          dio: Dio()..httpClientAdapter = mockAdapter,
        );
        expect(restClient.get('/test'), throwsA(isA<ConnectionException>()));
        expect(
          restClient.post('/test', body: {}),
          throwsA(isA<ConnectionException>()),
        );
        expect(restClient.delete('/test'), throwsA(isA<ConnectionException>()));
        expect(
          restClient.patch('/test', body: {}),
          throwsA(isA<ConnectionException>()),
        );
        expect(
          restClient.put('/test', body: {}),
          throwsA(isA<ConnectionException>()),
        );
      });

      test('Throws error when parsing wrong response on error for methods', () {
        final adapter = MockHttpAdapter()
          ..registerResponse(
            '/test',
            (req) => throw DioException.badResponse(
              requestOptions: req,
              statusCode: 400,
              response: Response(
                requestOptions: req,
                statusCode: 400,
                data: 123,
              ),
            ),
          );
        final restClient = RestClientDio(
          baseUrl: '',
          dio: Dio()..httpClientAdapter = adapter,
        );
        expect(
          restClient.get('/test'),
          throwsA(isA<WrongResponseTypeException>()),
        );
        expect(
          restClient.post('/test', body: {}),
          throwsA(isA<WrongResponseTypeException>()),
        );
        expect(
          restClient.delete('/test'),
          throwsA(isA<WrongResponseTypeException>()),
        );
        expect(
          restClient.patch('/test', body: {}),
          throwsA(isA<WrongResponseTypeException>()),
        );
        expect(
          restClient.put('/test', body: {}),
          throwsA(isA<WrongResponseTypeException>()),
        );
      });

      test('Decodes error properly for methods', () {
        final adapter = MockHttpAdapter()
          ..registerResponse(
            '/test',
            (req) => throw DioException.badResponse(
              requestOptions: req,
              statusCode: 400,
              response: Response(
                requestOptions: req,
                statusCode: 400,
                data: {
                  'error': {'message': 'test'},
                },
              ),
            ),
          );
        final restClient = RestClientDio(
          baseUrl: '',
          dio: Dio()..httpClientAdapter = adapter,
        );
        expect(
          restClient.get('/test'),
          throwsA(
            predicate<RestClientException>((p) => p.message == 'test'),
          ),
        );
        expect(
          restClient.post('/test', body: {}),
          throwsA(
            predicate<RestClientException>((p) => p.message == 'test'),
          ),
        );
        expect(
          restClient.delete('/test'),
          throwsA(
            predicate<RestClientException>((p) => p.message == 'test'),
          ),
        );
        expect(
          restClient.patch('/test', body: {}),
          throwsA(
            predicate<RestClientException>((p) => p.message == 'test'),
          ),
        );
        expect(
          restClient.put('/test', body: {}),
          throwsA(
            predicate<RestClientException>((p) => p.message == 'test'),
          ),
        );
      });
    });
  });
}

final class MockHttpAdapter implements HttpClientAdapter {
  MockHttpAdapter();

  final _responses = <String, ResponseBody Function(RequestOptions options)>{};

  void registerResponse(
    String path,
    ResponseBody Function(RequestOptions options) response,
  ) {
    _responses[path] = response;
  }

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    final req = options.path.replaceAll("?", "");

    if (_responses.containsKey(req)) {
      final response = _responses[req]!;

      return response(options);
    }

    throw Exception('No key was specified');
  }

  @override
  void close({bool force = false}) {}
}

/// Class used to test RestClientBase
///
/// Other methods are just stubs
final class _RestClientBase extends RestClientBase {
  _RestClientBase() : super(baseUrl: '');

  @override
  Future<Map<String, Object?>> delete(
    String path, {
    Map<String, Object?>? headers,
    Map<String, Object?>? queryParams,
  }) async {
    throw UnimplementedError();
  }

  @override
  Future<Map<String, Object?>> get(
    String path, {
    Map<String, Object?>? headers,
    Map<String, Object?>? queryParams,
  }) async {
    throw UnimplementedError();
  }

  @override
  Future<Map<String, Object?>> patch(
    String path, {
    Map<String, Object?>? body,
    Map<String, Object?>? headers,
    Map<String, Object?>? queryParams,
  }) async {
    throw UnimplementedError();
  }

  @override
  Future<Map<String, Object?>> post(
    String path, {
    Map<String, Object?>? body,
    Map<String, Object?>? headers,
    Map<String, Object?>? queryParams,
  }) async {
    throw UnimplementedError();
  }

  @override
  Future<Map<String, Object?>> put(
    String path, {
    Map<String, Object?>? body,
    Map<String, Object?>? headers,
    Map<String, Object?>? queryParams,
  }) async {
    throw UnimplementedError();
  }
}
