import 'package:flutter_test/flutter_test.dart';
import 'package:sizzle_starter/src/core/rest_client/rest_client.dart';

void main() {
  group(
    'RestClient >',
    () {
      group('decodeResponse >', () {
        late RestClientBase restClient;

        setUp(() => restClient = _RestClientBase());
        test('Should decode String', () async {
          const response = '{"data": {"test": "test"}}';
          final result = restClient.decodeResponse(response);
          await expectLater(
            result,
            completion(
              equals(
                {'test': 'test'},
              ),
            ),
          );
        });

        test('Should decode List<int>', () async {
          const response = [123, 34, 100, 97, 116, 97, 34, 58, 123, 125, 125];
          final result = restClient.decodeResponse(response);
          await expectLater(
            result,
            completion(
              equals({}),
            ),
          );
        });

        test('Should decode Map<String, Object?>', () async {
          const response = {
            'data': {'test': 'test'},
          };
          final result = restClient.decodeResponse(response);
          await expectLater(
            result,
            completion(
              equals(
                {'test': 'test'},
              ),
            ),
          );
        });

        test('Should throw RestClientException', () async {
          const response = 123;
          final result = restClient.decodeResponse(response);
          await expectLater(
            result,
            throwsA(
              isA<RestClientException>(),
            ),
          );
        });
      });
    },
  );
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
