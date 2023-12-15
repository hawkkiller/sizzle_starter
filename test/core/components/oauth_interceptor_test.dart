import 'dart:async';

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

class MockErrorInterceptorHandler extends Mock
    implements ErrorInterceptorHandler {}

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
      test('Adds AccessToken to Request Headers if Available', () async {
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

        await interceptor.onRequest(options, handler);
        verify(() => handler.next(options)).called(1);

        expect(
          options.headers,
          {'Authorization': 'Bearer ${mockTokenPair.accessToken}'},
        );
      });

      test('Proceeds Without Error When No Tokens Are Present', () async {
        final storage = InMemoryTokenStorage();
        final refreshClient = MockRefreshClient();
        final interceptor = OAuthInterceptor(
          storage: storage,
          refreshClient: refreshClient,
        );
        final options = RequestOptions(path: '/test');

        final handler = MockRequestInterceptorHandler();

        await expectLater(
          interceptor.onRequest(options, handler),
          completes,
        );

        verify(() => handler.next(options));
      });

      test('Rethrows Exception When Token Storage Access Fails', () async {
        final storage = MockTokenStorage();
        final refreshClient = MockRefreshClient();
        when(() => storage.getTokenPairStream())
            .thenAnswer((invocation) => const Stream.empty());

        when(() => storage.loadTokenPair()).thenThrow(Exception('Test Error'));
        when(() => storage.clearTokenPair()).thenAnswer((_) => Future.value());

        final interceptor = OAuthInterceptor(
          storage: storage,
          refreshClient: refreshClient,
        );
        final options = RequestOptions(path: '/test');

        final handler = MockRequestInterceptorHandler();

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

        verifyNever(() => handler.next(options));
      });
    });
    group('On Response >', () {
      test('Calls Next Handler on Successful API Response', () async {
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

        await expectLater(
          interceptor.onResponse(response, handler),
          completes,
        );

        verify(() => handler.next(response)).called(1);
      });
      test(
        'Throws Exception When Error Occurs in Token Storage During Response',
        () {
          final storage = MockTokenStorage();
          when(() => storage.getTokenPairStream())
              .thenAnswer((invocation) => const Stream.empty());
          when(() => storage.loadTokenPair())
              .thenThrow(Exception('Test Error'));
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

          verifyNever(() => handler.next(response));
        },
      );
      test(
        'Preloads TokenPair from Storage on Initial Setup',
        () async {
          final storage = InMemoryTokenStorage(
            accessToken: mockTokenPair.accessToken,
            refreshToken: mockTokenPair.refreshToken,
          );
          final refreshClient = MockRefreshClient();
          final interceptor = OAuthInterceptor(
            storage: storage,
            refreshClient: refreshClient,
          );

          await expectLater(
            interceptor.getAuthenticationStatusStream(),
            emitsInOrder([
              AuthenticationStatus.initial,
              AuthenticationStatus.authenticated,
            ]),
          );
        },
        timeout: const Timeout(Duration(seconds: 1)),
      );
      test(
        'Emits Unauthenticated Status When TokenPair is Empty',
        () async {
          final storage = InMemoryTokenStorage();
          final refreshClient = MockRefreshClient();
          final interceptor = OAuthInterceptor(
            storage: storage,
            refreshClient: refreshClient,
          );

          await expectLater(
            interceptor.getAuthenticationStatusStream(),
            emitsInOrder([
              AuthenticationStatus.initial,
              AuthenticationStatus.unauthenticated,
            ]),
          );
        },
        timeout: const Timeout(Duration(seconds: 1)),
      );

      test('Caches Token Storage Access on Consecutive Calls', () {
        final storage = MockTokenStorage();
        when(() => storage.getTokenPairStream())
            .thenAnswer((invocation) => const Stream.empty());
        final refreshClient = MockRefreshClient();
        when(() => storage.loadTokenPair()).thenAnswer(
          (_) => Future.value(mockTokenPair),
        );

        when(() => storage.getTokenPairStream()).thenAnswer(
          (_) => Stream.value(mockTokenPair),
        );

        final interceptor = OAuthInterceptor(
          storage: storage,
          refreshClient: refreshClient,
        );

        interceptor.getTokenPair();
        interceptor.getTokenPair();

        verify(() => storage.loadTokenPair()).called(1);
      });

      test('Caches tokens', () async {
        final storage = MockTokenStorage();
        when(() => storage.getTokenPairStream())
            .thenAnswer((invocation) => const Stream.empty());
        final refreshClient = MockRefreshClient();

        final streamController = StreamController<TokenPair?>.broadcast();

        when(() => storage.loadTokenPair()).thenAnswer(
          (_) => Future.value(mockTokenPair),
        );

        when(() => storage.clearTokenPair()).thenAnswer(
          (_) => Future.value(),
        );

        when(() => storage.getTokenPairStream()).thenAnswer(
          (_) => streamController.stream,
        );

        final interceptor = OAuthInterceptor(
          storage: storage,
          refreshClient: refreshClient,
        );

        await interceptor.getTokenPair();
        await interceptor.clearTokenPair();
        await interceptor.getTokenPair();

        verify(() => storage.loadTokenPair()).called(1);
        await streamController.close();
      });

      test('Emits Unauthenticated Status After Clearing TokenPair', () async {
        final storage = InMemoryTokenStorage(
          accessToken: mockTokenPair.accessToken,
          refreshToken: mockTokenPair.refreshToken,
        );
        final refreshClient = MockRefreshClient();
        final interceptor = OAuthInterceptor(
          storage: storage,
          refreshClient: refreshClient,
        );

        await expectLater(
          interceptor.getAuthenticationStatusStream(),
          emitsInOrder([
            AuthenticationStatus.initial,
            AuthenticationStatus.authenticated,
          ]),
        );

        interceptor.clearTokenPair().ignore();

        await expectLater(
          interceptor.getAuthenticationStatusStream(),
          emitsInOrder([
            AuthenticationStatus.authenticated,
            AuthenticationStatus.unauthenticated,
          ]),
        );
      });
      test(
        'Successfully Refreshes Token Upon Receiving 401 Status Code',
        () async {
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
            retryClient: baseClient,
          );
          final response = Response(
            requestOptions: RequestOptions(path: '/test'),
            statusCode: 401,
            data: const <String, String>{},
          );

          final handler = MockResponseInterceptorHandler();

          when(() => refreshClient.refreshToken(any())).thenAnswer(
            (_) => Future.value(mockTokenPair),
          );

          await expectLater(
            interceptor.onResponse(response, handler),
            completes,
          );

          verify(() => handler.resolve(any())).called(1);
        },
      );
      test('Clears Tokens and Emits Status on RevokeTokenException', () async {
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
          retryClient: baseClient,
        );
        final response = Response(
          requestOptions: RequestOptions(path: '/test'),
          statusCode: 401,
          data: const <String, String>{},
        );

        final handler = MockResponseInterceptorHandler();

        when(() => refreshClient.refreshToken(any())).thenThrow(
          const RevokeTokenException(),
        );

        await expectLater(
          interceptor.onResponse(response, handler),
          throwsA(isA<RevokeTokenException>()),
        );

        await expectLater(
          interceptor.getAuthenticationStatusStream(),
          emits(AuthenticationStatus.unauthenticated),
        );
      });
      test('Throws Exception on Token Refresh Failure During Response', () {
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

        when(() => refreshClient.refreshToken(any())).thenThrow(
          Exception('Test Error'),
        );

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

        verifyNever(() => handler.next(response));
      });
    });
    group('On Error', () {
      test('Should refresh on error', () async {
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
          retryClient: baseClient,
        );
        final error = DioException(
          requestOptions: RequestOptions(path: '/test'),
          error: 'Test Error',
          response: Response(
            requestOptions: RequestOptions(path: '/test'),
            statusCode: 401,
            data: const <String, String>{},
          ),
        );

        final handler = MockErrorInterceptorHandler();

        when(() => refreshClient.refreshToken(any())).thenAnswer(
          (_) => Future.value(mockTokenPair),
        );

        await expectLater(interceptor.onError(error, handler), completes);

        verify(() => handler.resolve(any())).called(1);
      });

      test('Handler next is called on refresh if DioException', () async {
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
          retryClient: baseClient,
        );
        final error = DioException(
          requestOptions: RequestOptions(path: '/test'),
          error: 'Test Error',
          response: Response(
            requestOptions: RequestOptions(path: '/test'),
            statusCode: 401,
            data: const <String, String>{},
          ),
        );

        final handler = MockErrorInterceptorHandler();

        when(() => refreshClient.refreshToken(any())).thenAnswer(
          (_) => throw error,
        );

        await expectLater(interceptor.onError(error, handler), completes);

        verify(() => handler.next(error));
      });

      test("If error code is not 401, it doesn't refresh", () async {
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
          retryClient: baseClient,
        );
        final error = DioException(
          requestOptions: RequestOptions(path: '/test'),
          error: 'Test Error',
          response: Response(
            requestOptions: RequestOptions(path: '/test'),
            statusCode: 400,
            data: const <String, String>{},
          ),
        );

        final handler = MockErrorInterceptorHandler();

        when(() => refreshClient.refreshToken(any())).thenAnswer(
          (_) => Future.value(mockTokenPair),
        );

        await expectLater(interceptor.onError(error, handler), completes);

        verify(() => handler.next(error)).called(1);
      });
    });
  });
}
