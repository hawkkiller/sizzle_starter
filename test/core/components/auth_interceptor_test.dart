import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sizzle_starter/src/core/components/rest_client/rest_client.dart';
import 'package:sizzle_starter/src/core/components/rest_client/src/auth/refresh_client.dart';

import 'rest_client_test.dart';

/// A pair of Auth tokens.
///
/// The **accessToken** is used to authenticate the request.
///
/// The **refreshToken** is used to refresh the accessToken.
typedef TokenPair = ({String accessToken, String refreshToken});

/// InMemoryTokenStorage is an in-memory implementation of [TokenStorage].
/// Generally, this should only be used for testing.
class InMemoryTokenStorage implements TokenStorage<TokenPair> {
  /// Create an in-memory token storage.
  InMemoryTokenStorage({String? accessToken, String? refreshToken}) {
    if (accessToken != null) {
      _storage['accessToken'] = accessToken;
    }
    if (refreshToken != null) {
      _storage['refreshToken'] = refreshToken;
    }
  }

  final _storage = <String, String>{};
  final _controller = StreamController<TokenPair?>.broadcast();

  @override
  Future<void> saveTokenPair(TokenPair tokenPair) async {
    _storage['accessToken'] = tokenPair.accessToken;
    _storage['refreshToken'] = tokenPair.refreshToken;
    _controller.add(tokenPair);
  }

  @override
  Future<TokenPair?> loadTokenPair() async {
    final accessToken = _storage['accessToken'];
    final refreshToken = _storage['refreshToken'];
    if (accessToken != null && refreshToken != null) {
      return (accessToken: accessToken, refreshToken: refreshToken);
    }
    return null;
  }

  @override
  Future<void> clearTokenPair() async {
    _storage.remove('accessToken');
    _storage.remove('refreshToken');
    _controller.add(null);
  }

  @override
  Stream<TokenPair?> getTokenPairStream() => _controller.stream;

  @override
  Future<void> close() => _controller.close();
}

const TokenPair mockTokenPair = (
  accessToken: 'Access Token',
  refreshToken: 'RefreshToken',
);

class MockRefreshClient extends Mock implements RefreshClient<TokenPair> {}

class MockRequestInterceptorHandler extends Mock
    implements RequestInterceptorHandler {}

class MockResponseInterceptorHandler extends Mock
    implements ResponseInterceptorHandler {}

class MockErrorInterceptorHandler extends Mock
    implements ErrorInterceptorHandler {}

class MockTokenStorage extends Mock implements TokenStorage<TokenPair> {}

Map<String, String> buildHeaders(TokenPair pair) =>
    {'Authorization': 'Bearer ${pair.accessToken}'};

void main() {
  group('Auth Interceptor', () {
    late InMemoryTokenStorage memStorageWithToken;
    late InMemoryTokenStorage memStorageWithoutToken;
    late MockRefreshClient refreshClientSuccess;
    late MockRefreshClient refreshClientError;

    setUp(() {
      memStorageWithToken = InMemoryTokenStorage(
        accessToken: mockTokenPair.accessToken,
        refreshToken: mockTokenPair.refreshToken,
      );
      memStorageWithoutToken = InMemoryTokenStorage();
      refreshClientSuccess = MockRefreshClient();
      when(() => refreshClientSuccess.refreshToken(any())).thenAnswer(
        (_) => Future.value(mockTokenPair),
      );
      refreshClientError = MockRefreshClient();
      when(() => refreshClientError.refreshToken(any())).thenThrow(
        const RevokeTokenException(),
      );
    });

    tearDown(() {
      memStorageWithToken.close();
      memStorageWithoutToken.close();
      resetMocktailState();
    });

    setUpAll(() {
      registerFallbackValue(RequestOptions(path: '/test'));
      registerFallbackValue(
        Response(
          requestOptions: RequestOptions(path: '/test'),
          statusCode: 200,
          data: const <String, String>{},
        ),
      );
      registerFallbackValue(mockTokenPair);
    });
    group('On Request >', () {
      test('Adds AccessToken to Request Headers if Available', () async {
        final interceptor = AuthInterceptor(
          storage: memStorageWithToken,
          refreshClient: refreshClientSuccess,
          buildHeaders: buildHeaders,
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
        final interceptor = AuthInterceptor(
          storage: memStorageWithoutToken,
          refreshClient: refreshClientSuccess,
          buildHeaders: buildHeaders,
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
        when(() => storage.getTokenPairStream()).thenAnswer(
          (_) => const Stream.empty(),
        );

        when(() => storage.loadTokenPair()).thenThrow(Exception('Test Error'));
        when(() => storage.clearTokenPair()).thenAnswer((_) => Future.value());

        final interceptor = AuthInterceptor(
          storage: storage,
          refreshClient: refreshClientSuccess,
          buildHeaders: buildHeaders,
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
        final interceptor = AuthInterceptor(
          storage: memStorageWithToken,
          refreshClient: refreshClientSuccess,
          buildHeaders: buildHeaders,
        );
        final response = Response(
          requestOptions: RequestOptions(),
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
        'Preloads TokenPair from Storage on Initial Setup',
        () async {
          final interceptor = AuthInterceptor(
            storage: memStorageWithToken,
            refreshClient: refreshClientSuccess,
            buildHeaders: buildHeaders,
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
          final interceptor = AuthInterceptor(
            storage: memStorageWithoutToken,
            refreshClient: refreshClientSuccess,
            buildHeaders: buildHeaders,
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

        final interceptor = AuthInterceptor(
          storage: storage,
          refreshClient: refreshClient,
          buildHeaders: buildHeaders,
        );

        interceptor.getTokenPair();
        interceptor.getTokenPair();

        verify(() => storage.loadTokenPair()).called(1);
      });

      test('Caches token pair value', () async {
        final storage = MockTokenStorage();
        when(() => storage.getTokenPairStream()).thenAnswer(
          (invocation) => const Stream.empty(),
        );

        when(() => storage.loadTokenPair()).thenAnswer(
          (_) => Future.value(mockTokenPair),
        );

        when(() => storage.clearTokenPair()).thenAnswer(
          (_) => Future.value(),
        );

        final interceptor = AuthInterceptor(
          storage: storage,
          refreshClient: refreshClientSuccess,
          buildHeaders: buildHeaders,
        );

        await interceptor.getTokenPair();
        await interceptor.clearTokenPair();
        await interceptor.getTokenPair();

        verify(() => storage.loadTokenPair()).called(1);
      });

      test('Emits Unauthenticated Status After Clearing TokenPair', () async {
        final interceptor = AuthInterceptor(
          storage: memStorageWithToken,
          refreshClient: refreshClientSuccess,
          buildHeaders: buildHeaders,
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
      test('Refreshes Token Upon Receiving 401 Status Code', () async {
        final mockAdapter = MockHttpAdapter()
          ..registerResponse(
            '/test',
            (options) => ResponseBody.fromString('{"test": "test"}', 200),
          );
        final retryClient = Dio()..httpClientAdapter = mockAdapter;
        final interceptor = AuthInterceptor(
          storage: memStorageWithToken,
          refreshClient: refreshClientSuccess,
          retryClient: retryClient,
          buildHeaders: buildHeaders,
        );
        final response = Response(
          requestOptions: RequestOptions(path: '/test'),
          statusCode: 401,
          data: const <String, String>{},
        );

        final handler = MockResponseInterceptorHandler();

        await expectLater(
          interceptor.onResponse(response, handler),
          completes,
        );

        verify(() => handler.resolve(any())).called(1);
      });
      test('Clears Tokens and Emits Status on RevokeTokenException', () async {
        final mockAdapter = MockHttpAdapter()
          ..registerResponse(
            '/test',
            (options) => ResponseBody.fromString('{"test": "test"}', 200),
          );
        final baseClient = Dio()..httpClientAdapter = mockAdapter;
        final interceptor = AuthInterceptor(
          storage: memStorageWithToken,
          refreshClient: refreshClientError,
          retryClient: baseClient,
          buildHeaders: buildHeaders,
        );
        final response = Response(
          requestOptions: RequestOptions(path: '/test'),
          statusCode: 401,
          data: const <String, String>{},
        );

        final handler = MockResponseInterceptorHandler();

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
        final refreshClient = MockRefreshClient();
        final interceptor = AuthInterceptor(
          storage: memStorageWithToken,
          buildHeaders: buildHeaders,
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
        final mockAdapter = MockHttpAdapter()
          ..registerResponse(
            '/test',
            (options) => ResponseBody.fromString('{"test": "test"}', 200),
          );
        final baseClient = Dio()..httpClientAdapter = mockAdapter;
        final interceptor = AuthInterceptor(
          storage: memStorageWithToken,
          refreshClient: refreshClientSuccess,
          retryClient: baseClient,
          buildHeaders: buildHeaders,
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

        await expectLater(interceptor.onError(error, handler), completes);

        verify(() => handler.resolve(any())).called(1);
      });

      test('Handler next is called on refresh if DioException', () async {
        final refreshClient = MockRefreshClient();
        final mockAdapter = MockHttpAdapter()
          ..registerResponse(
            '/test',
            (options) => ResponseBody.fromString('{"test": "test"}', 200),
          );
        final baseClient = Dio()..httpClientAdapter = mockAdapter;
        final interceptor = AuthInterceptor(
          storage: memStorageWithToken,
          refreshClient: refreshClient,
          retryClient: baseClient,
          buildHeaders: buildHeaders,
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
        final mockAdapter = MockHttpAdapter()
          ..registerResponse(
            '/test',
            (options) => ResponseBody.fromString('{"test": "test"}', 200),
          );
        final baseClient = Dio()..httpClientAdapter = mockAdapter;
        final interceptor = AuthInterceptor(
          storage: memStorageWithToken,
          refreshClient: refreshClientSuccess,
          retryClient: baseClient,
          buildHeaders: buildHeaders,
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

        await expectLater(interceptor.onError(error, handler), completes);

        verify(() => handler.next(error)).called(1);
      });
    });
  });
}
