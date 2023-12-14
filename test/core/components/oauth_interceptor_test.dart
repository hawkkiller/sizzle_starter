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

      test('Should not fail if no tokens', () async {
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

      test('Should rethrow on storage exception', () async {
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
      test('Calls next on successful response', () async {
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
      test('Throws on storage exception', () {
        final storage = MockTokenStorage();
        when(() => storage.getTokenPairStream())
            .thenAnswer((invocation) => const Stream.empty());
        when(() => storage.loadTokenPair()).thenThrow(Exception('Test Error'));
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
      });
      test('Throws on refresh exception', () {
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
      test(
        'Preloads initial tokenPair from database',
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
        'Emits unauthenticated when tokenPair is empty',
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

      test('Two consequtive calls to storage are cached', () {
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

      test('Tokens should be cached in interceptor', () async {
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

      test('After clearing token pair, unauthenticated emits', () async {
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
      test('Refreshes normally', () async {
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

        when(() => refreshClient.refreshToken(any())).thenAnswer(
          (_) => Future.value(mockTokenPair),
        );

        await expectLater(interceptor.onResponse(response, handler), completes);

        verify(() => handler.resolve(any())).called(1);
      });
      test('RevokeTokenException clears token', () async {
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
    });
  });
}
