import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sizzle_starter/src/core/rest_client/rest_client.dart';
import 'package:sizzle_starter/src/core/rest_client/src/rest_client_dio.dart';

void main() {
  group(
    'RestClient >',
    () {
      group('decodeResponse >', () {
        late RestClientBase restClient;

        setUp(() => restClient = _RestClientBase());
        test('Should decode String', () {
          const response = '{"data": {"test": "test"}}';
          final result = restClient.decodeResponse(response);
          expect(
            result,
            completion(
              equals(
                {'test': 'test'},
              ),
            ),
          );
        });

        test('Should decode List<int>', () {
          const response = [123, 34, 100, 97, 116, 97, 34, 58, 123, 125, 125];
          final result = restClient.decodeResponse(response);
          expectLater(
            result,
            completion(
              equals({}),
            ),
          );
        });

        test('Should decode Map<String, Object?>', () {
          const response = {
            'data': {'test': 'test'},
          };
          final result = restClient.decodeResponse(response);
          expect(
            result,
            completion(
              equals(
                {'test': 'test'},
              ),
            ),
          );
        });

        test('Should throw WrongResponseTypeException', () {
          const response = 123;
          final result = restClient.decodeResponse(response);
          expect(
            result,
            throwsA(
              isA<WrongResponseTypeException>(),
            ),
          );
        });

        test('Return null when no data', () {
          const response = {'test': 'test'};
          final result = restClient.decodeResponse(response);
          expect(result, completion(isNull));
        });

        test('Return null when null response', () {
          final result = restClient.decodeResponse(null);
          expect(result, completion(isNull));
        });

        test(
          'Throw if error field in JSON',
          () {
            const response = '{"error": {"message": "test"}}';
            final result = restClient.decodeResponse(response);
            expect(
              result,
              throwsA(
                predicate<RestClientException>(
                  (p) => p.message == 'test',
                ),
              ),
            );
          },
        );
      });

      group('RestClientDio >', () {
        late RestClientDio restClient;

        setUp(
          () => restClient = RestClientDio(
            baseUrl: '',
            dio: Dio()..httpClientAdapter = const _MockHttpAdapter(),
          ),
        );

        test(
          'Decodes and returns response',
          () => expect(
            restClient.get(''),
            completion(
              equals({'test': 'test'}),
            ),
          ),
        );

        test(
          'Throws RestClientException',
          () {
            restClient = RestClientDio(
              baseUrl: '',
              dio: Dio()
                ..httpClientAdapter = const _MockHttpAdapter(
                  returnError: true,
                ),
            );
            expect(
              restClient.get(''),
              throwsA(
                predicate<RestClientException>(
                  (p) => p.message == 'test',
                ),
              ),
            );
          },
        );

        test('Throws ConnectionException', () {
          restClient = RestClientDio(
            baseUrl: '',
            dio: Dio()
              ..httpClientAdapter = _MockHttpAdapter(
                runBeforeFetch: (req) {
                  throw DioException.connectionError(
                    requestOptions: req,
                    reason: 'No Internet!',
                  );
                },
              ),
          );
          expect(
            restClient.get(''),
            throwsA(isA<ConnectionException>()),
          );
        });

        test('Throws error when parsing wrong response on error', () {
          restClient = RestClientDio(
            baseUrl: '',
            dio: Dio()
              ..httpClientAdapter = _MockHttpAdapter(
                runBeforeFetch: (req) {
                  throw DioException.badResponse(
                    requestOptions: req,
                    statusCode: 400,
                    response: Response(
                      requestOptions: req,
                      statusCode: 400,
                      data: 123,
                    ),
                  );
                },
              ),
          );
          expect(
            restClient.get(''),
            throwsA(isA<WrongResponseTypeException>()),
          );
        });

        test('Decodes error properly', () {
          restClient = RestClientDio(
            baseUrl: '',
            dio: Dio()
              ..httpClientAdapter = _MockHttpAdapter(
                runBeforeFetch: (req) {
                  throw DioException.badResponse(
                    requestOptions: req,
                    statusCode: 400,
                    response: Response(
                      requestOptions: req,
                      statusCode: 400,
                      data: {
                        'error': {'message': 'test'},
                      },
                    ),
                  );
                },
              ),
          );
          expect(
            restClient.get(''),
            throwsA(
              predicate<RestClientException>(
                (p) => p.message == 'test',
              ),
            ),
          );
        });
      });
    },
  );
}

final class _MockHttpAdapter implements HttpClientAdapter {
  const _MockHttpAdapter({
    this.returnError = false,
    this.runBeforeFetch,
  });

  final bool returnError;
  final void Function(RequestOptions)? runBeforeFetch;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    runBeforeFetch?.call(options);
    if (returnError) {
      return ResponseBody.fromString(
        '{"error": {"message": "test"}}',
        400,
      );
    }
    return ResponseBody.fromString(
      '{"data": {"test": "test"}}',
      200,
    );
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
