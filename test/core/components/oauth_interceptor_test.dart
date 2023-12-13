import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sizzle_starter/src/core/components/rest_client/rest_client.dart';
import 'package:sizzle_starter/src/core/components/rest_client/src/oauth/refresh_client.dart';

import 'rest_client_test.dart';

const TokenPair mockTokenPair = (
  accessToken: 'Access Token',
  refreshToken: 'RefreshToken',
);

class MockRefreshClient extends Mock implements RefreshClient {}

class MockRequestInterceptorHandler extends Mock
    implements RequestInterceptorHandler {}

class MockResponseInterceptorHandler extends Mock
    implements ResponseInterceptorHandler {}

class MockTokenStorage extends Mock implements TokenStorage {}

void main() {
  group('OAuth Interceptor', () {
    setUpAll(() {
      registerFallbackValue(RequestOptions(path: '/test'));
      registerFallbackValue(
        Response(
          requestOptions: RequestOptions(path: '/test'),
          statusCode: 200,
          data: const <String, String>{},
        ),
      );
    });
    group('On Request >', () {
      test('should add the access token to the request header', () async {
        // Arrange
        final storage = InMemoryTokenStorage(
          accessToken: mockTokenPair.accessToken,
          refreshToken: mockTokenPair.refreshToken,
        );
        final refreshClient = MockRefreshClient();
        final interceptor = OAuthInterceptor(
          storage: storage,
          refreshClient: refreshClient,
        );
        final options = RequestOptions(path: '/test');

        final handler = MockRequestInterceptorHandler();

        // Act
        await interceptor.onRequest(options, handler);
        verify(() => handler.next(options)).called(1);

        // Assert
        expect(
          options.headers,
          {'Authorization': 'Bearer ${mockTokenPair.accessToken}'},
        );
      });

      test('Should not fail if no tokens', () async {
        // Arrange
        final storage = InMemoryTokenStorage();
        final refreshClient = MockRefreshClient();
        final interceptor = OAuthInterceptor(
          storage: storage,
          refreshClient: refreshClient,
        );
        final options = RequestOptions(path: '/test');

        final handler = MockRequestInterceptorHandler();

        // Act
        await expectLater(
          interceptor.onRequest(options, handler),
          completes,
        );

        // Assert
        verify(() => handler.next(options));
      });

      test('Should rethrow on storage exception', () async {
        // Arrange
        final storage = MockTokenStorage();
        final refreshClient = MockRefreshClient();
        final interceptor = OAuthInterceptor(
          storage: storage,
          refreshClient: refreshClient,
        );
        final options = RequestOptions(path: '/test');

        final handler = MockRequestInterceptorHandler();

        when(() => storage.loadTokenPair()).thenThrow(Exception('Test Error'));

        when(() => storage.clearTokenPair()).thenAnswer((_) => Future.value());

        // Act
        await expectLater(
          () => interceptor.onRequest(options, handler),
          throwsA(
            isA<Exception>().having(
              (e) => e.toString(),
              'toString()',
              'Exception: Test Error',
            ),
          ),
        );

        // Assert
        verifyNever(() => handler.next(options));
      });
    });
    group('On Response >', () {
      test('Calls next on successful response', () async {
        // Arrange
        final storage = InMemoryTokenStorage(
          accessToken: mockTokenPair.accessToken,
          refreshToken: mockTokenPair.refreshToken,
        );
        final refreshClient = MockRefreshClient();
        final interceptor = OAuthInterceptor(
          storage: storage,
          refreshClient: refreshClient,
        );
        final response = Response(
          requestOptions: RequestOptions(path: '/test'),
          statusCode: 200,
          data: const <String, String>{},
        );

        final handler = MockResponseInterceptorHandler();

        // Act
        await expectLater(
          interceptor.onResponse(response, handler),
          completes,
        );

        // Assert
        verify(() => handler.next(response)).called(1);
      });
      test('Throws on storage exception', () {
        // Arrange
        final storage = MockTokenStorage();
        final refreshClient = MockRefreshClient();
        final interceptor = OAuthInterceptor(
          storage: storage,
          refreshClient: refreshClient,
        );
        final response = Response(
          requestOptions: RequestOptions(path: '/test'),
          statusCode: 200,
          data: const <String, String>{},
        );

        final handler = MockResponseInterceptorHandler();

        when(() => storage.loadTokenPair()).thenThrow(Exception('Test Error'));

        // Act
        expectLater(
          () => interceptor.onResponse(response, handler),
          throwsA(
            isA<Exception>().having(
              (e) => e.toString(),
              'toString()',
              'Exception: Test Error',
            ),
          ),
        );

        // Assert
        verifyNever(() => handler.next(response));
      });
      test('Throws on refresh exception', () {
        // Arrange
        final storage = InMemoryTokenStorage(
          accessToken: mockTokenPair.accessToken,
          refreshToken: mockTokenPair.refreshToken,
        );
        final refreshClient = MockRefreshClient();
        final interceptor = OAuthInterceptor(
          storage: storage,
          refreshClient: refreshClient,
        );
        final response = Response(
          requestOptions: RequestOptions(path: '/test'),
          statusCode: 401,
          data: const <String, String>{},
        );

        final handler = MockResponseInterceptorHandler();

        when(() => refreshClient.refresh(any())).thenThrow(
          Exception('Test Error'),
        );

        // Act
        expectLater(
          () => interceptor.onResponse(response, handler),
          throwsA(
            isA<Exception>().having(
              (e) => e.toString(),
              'toString()',
              'Exception: Test Error',
            ),
          ),
        );

        // Assert
        verifyNever(() => handler.next(response));
      });
      test('Refreshes normally', () async {
        // Arrange
        final storage = InMemoryTokenStorage(
          accessToken: mockTokenPair.accessToken,
          refreshToken: mockTokenPair.refreshToken,
        );
        final refreshClient = MockRefreshClient();
        final mockAdapter = MockHttpAdapter()
          ..registerResponse(
            '/test',
            (options) => ResponseBody.fromString('{"test": "test"}', 200),
          );
        final baseClient = Dio()..httpClientAdapter = mockAdapter;
        final interceptor = OAuthInterceptor(
          storage: storage,
          refreshClient: refreshClient,
          baseClient: baseClient,
        );
        final response = Response(
          requestOptions: RequestOptions(path: '/test'),
          statusCode: 401,
          data: const <String, String>{},
        );

        final handler = MockResponseInterceptorHandler();

        when(() => refreshClient.refresh(any())).thenAnswer(
          (_) => Future.value(mockTokenPair),
        );

        // Act
        await expectLater(interceptor.onResponse(response, handler), completes);

        // Assert
        verify(() => handler.resolve(any())).called(1);
      });
      
    });
  });
}
