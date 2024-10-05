import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:intercepted_client/intercepted_client.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:sizzle_starter/src/core/rest_client/src/auth/auth_interceptor.dart';
import 'package:sizzle_starter/src/core/rest_client/src/auth/authorization_client.dart';
import 'package:sizzle_starter/src/core/rest_client/src/auth/token_storage.dart';

@GenerateNiceMocks([
  MockSpec<AuthorizationClient<Token>>(),
  MockSpec<TokenStorage<Token>>(),
  MockSpec<RequestHandler>(),
  MockSpec<ResponseHandler>(),
])
import 'auth_interceptor_test.mocks.dart';

void main() {
  group('Auth Interceptor', () {
    late MockAuthorizationClient mockAuthorizationClient;
    late MockTokenStorage mockTokenStorage;
    late MockRequestHandler mockRequestHandler;
    late MockResponseHandler mockResponseHandler;

    setUp(() {
      mockAuthorizationClient = MockAuthorizationClient();
      mockTokenStorage = MockTokenStorage();
      mockRequestHandler = MockRequestHandler();
      mockResponseHandler = MockResponseHandler();
    });

    tearDown(() {
      reset(mockAuthorizationClient);
      reset(mockTokenStorage);
      reset(mockRequestHandler);
      reset(mockResponseHandler);
    });

    test('should reject request if token is null', () async {
      final authInterceptor = AuthInterceptor(
        tokenStorage: mockTokenStorage,
        authorizationClient: mockAuthorizationClient,
      );

      final request = http.Request('GET', Uri.parse('https://example.com'));

      await authInterceptor.interceptRequest(request, mockRequestHandler);
      verify(mockRequestHandler.rejectRequest(any));
      verifyNever(mockRequestHandler.resolveResponse(any));
    });

    test('should add authorization header if access token is valid', () async {
      final authInterceptor = AuthInterceptor(
        tokenStorage: mockTokenStorage,
        authorizationClient: mockAuthorizationClient,
        token: const Token('access_token', 'refresh_token'),
      );

      when(mockAuthorizationClient.isAccessTokenValid(any)).thenAnswer((_) => Future.value(true));

      final request = http.Request('GET', Uri.parse('https://example.com'));

      await authInterceptor.interceptRequest(request, mockRequestHandler);

      expect(
        request.headers['Authorization'],
        matches('Bearer access_token'),
      );
    });

    test(
      'should clear token and reject response on RevokeTokenException',
      () async {
        final authInterceptor = AuthInterceptor(
          tokenStorage: mockTokenStorage,
          authorizationClient: mockAuthorizationClient,
          token: const Token('access token', 'refresh token'),
        );

        final response = http.StreamedResponse(
          Stream.value([]),
          401,
          request: http.Request('GET', Uri.parse('https://example.com'))
            ..headers['Authorization'] = 'Bearer access token',
        );

        when(mockAuthorizationClient.isAccessTokenValid(any))
            .thenAnswer((_) => Future.value(false));
        when(mockAuthorizationClient.isRefreshTokenValid(any))
            .thenAnswer((_) => Future.value(true));
        when(mockAuthorizationClient.refresh(any)).thenThrow(
          const RevokeTokenException(
            'Token is not valid and cannot be refreshed',
          ),
        );
        when(mockTokenStorage.clear()).thenAnswer((_) => Future.value());

        await authInterceptor.interceptResponse(response, mockResponseHandler);

        verify(mockTokenStorage.clear());
        verify(mockResponseHandler.rejectResponse(any));
        verifyNever(mockResponseHandler.resolveResponse(any));
      },
    );

    test(
      'should reject request if error happens during refresh',
      () async {
        final authInterceptor = AuthInterceptor(
          tokenStorage: mockTokenStorage,
          authorizationClient: mockAuthorizationClient,
          token: const Token('access token', 'refresh token'),
        );

        final request = http.Request('GET', Uri.parse('https://example.com'));

        when(mockAuthorizationClient.isAccessTokenValid(any))
            .thenAnswer((_) => Future.value(false));
        when(mockAuthorizationClient.isRefreshTokenValid(any))
            .thenAnswer((_) => Future.value(true));
        when(mockAuthorizationClient.refresh(any)).thenThrow(Exception());

        await authInterceptor.interceptRequest(request, mockRequestHandler);

        verify(mockRequestHandler.rejectRequest(any));
        verifyNever(mockRequestHandler.resolveResponse(any));
      },
    );

    test(
      'should refresh token if access token '
      'is invalid but refresh token is valid',
      () async {
        final authInterceptor = AuthInterceptor(
          tokenStorage: mockTokenStorage,
          authorizationClient: mockAuthorizationClient,
          token: const Token('access_token', 'refresh_token'),
        );

        when(mockAuthorizationClient.isAccessTokenValid(any))
            .thenAnswer((_) => Future.value(false));
        when(mockAuthorizationClient.isRefreshTokenValid(any))
            .thenAnswer((_) => Future.value(true));
        when(mockAuthorizationClient.refresh(any)).thenAnswer(
          (_) => Future.value(
            const Token('new_access_token', 'new_refresh_token'),
          ),
        );

        final request = http.Request('GET', Uri.parse('https://example.com'));

        await authInterceptor.interceptRequest(request, mockRequestHandler);

        verify(
          mockAuthorizationClient.refresh(
            const Token('access_token', 'refresh_token'),
          ),
        );

        expect(
          request.headers['Authorization'],
          matches('Bearer new_access_token'),
        );
      },
    );

    test(
      'should reject request if both access and refresh tokens are invalid',
      () async {
        final authInterceptor = AuthInterceptor(
          tokenStorage: mockTokenStorage,
          authorizationClient: mockAuthorizationClient,
          token: const Token('access token', 'refresh token'),
        );

        when(mockAuthorizationClient.isAccessTokenValid(any))
            .thenAnswer((_) => Future.value(false));
        when(mockAuthorizationClient.isRefreshTokenValid(any))
            .thenAnswer((_) => Future.value(false));

        final request = http.Request('GET', Uri.parse('https://example.com'));

        await authInterceptor.interceptRequest(request, mockRequestHandler);

        verify(mockRequestHandler.rejectRequest(any));
        verifyNever(mockRequestHandler.resolveResponse(any));
      },
    );

    test('should resolve response if status code is not 401', () async {
      final authInterceptor = AuthInterceptor(
        tokenStorage: mockTokenStorage,
        authorizationClient: mockAuthorizationClient,
        token: const Token('access token', 'refresh token'),
      );

      final response = http.StreamedResponse(
        Stream.value([]),
        200,
        headers: {},
      );

      await authInterceptor.interceptResponse(response, mockResponseHandler);

      verify(mockResponseHandler.resolveResponse(response)).called(1);
    });

    test(
      'if response doesnt have token in request, resolve response',
      () async {
        final authInterceptor = AuthInterceptor(
          tokenStorage: mockTokenStorage,
          authorizationClient: mockAuthorizationClient,
          token: const Token('access token', 'refresh token'),
        );

        final response = http.StreamedResponse(
          Stream.value([]),
          401,
          request: http.Request('GET', Uri.parse('https://example.com')),
        );

        await authInterceptor.interceptResponse(response, mockResponseHandler);

        verify(mockResponseHandler.resolveResponse(response));
        verifyNever(mockResponseHandler.rejectResponse(any));
      },
    );

    test(
      'should clear tokens and reject response '
      'on RevokeTokenException in interceptResponse',
      () async {
        final authInterceptor = AuthInterceptor(
          tokenStorage: mockTokenStorage,
          authorizationClient: mockAuthorizationClient,
          token: const Token('access token', 'refresh token'),
        );

        final response = http.StreamedResponse(
          Stream.value([]),
          401,
          request: http.Request('GET', Uri.parse('https://example.com'))
            ..headers['Authorization'] = 'Bearer access token',
        );

        when(mockAuthorizationClient.isAccessTokenValid(any))
            .thenAnswer((_) => Future.value(false));
        when(mockAuthorizationClient.isRefreshTokenValid(any))
            .thenAnswer((_) => Future.value(true));
        when(mockAuthorizationClient.refresh(any)).thenThrow(
          const RevokeTokenException(
            'Token is not valid and cannot be refreshed',
          ),
        );
        when(mockTokenStorage.clear()).thenAnswer((_) => Future.value());

        await authInterceptor.interceptResponse(response, mockResponseHandler);

        verify(mockTokenStorage.clear());
        verify(mockResponseHandler.rejectResponse(any));
        verifyNever(mockResponseHandler.resolveResponse(any));
      },
    );

    test(
      'should reject response if error happens during refresh',
      () async {
        final authInterceptor = AuthInterceptor(
          tokenStorage: mockTokenStorage,
          authorizationClient: mockAuthorizationClient,
          token: const Token('access token', 'refresh token'),
        );

        final response = http.StreamedResponse(
          Stream.value([]),
          401,
          request: http.Request('GET', Uri.parse('https://example.com'))
            ..headers['Authorization'] = 'Bearer access token',
        );

        when(mockAuthorizationClient.isAccessTokenValid(any))
            .thenAnswer((_) => Future.value(false));
        when(mockAuthorizationClient.isRefreshTokenValid(any))
            .thenAnswer((_) => Future.value(true));
        when(mockAuthorizationClient.refresh(any)).thenThrow(Exception());

        await authInterceptor.interceptResponse(response, mockResponseHandler);

        verify(mockResponseHandler.rejectResponse(any));
        verifyNever(mockResponseHandler.resolveResponse(any));
      },
    );

    test(
      'should reject response if status code is 401 and token is null',
      () async {
        final authInterceptor = AuthInterceptor(
          tokenStorage: mockTokenStorage,
          authorizationClient: mockAuthorizationClient,
        );

        final response = http.StreamedResponse(
          Stream.value([]),
          401,
          headers: {},
        );

        await authInterceptor.interceptResponse(response, mockResponseHandler);

        verify(mockResponseHandler.rejectResponse(any));
        verifyNever(mockResponseHandler.resolveResponse(any));
      },
    );

    test(
      'should refresh token and retry request '
      'if status code is 401 and token is valid',
      () async {
        final authInterceptor = AuthInterceptor(
          tokenStorage: mockTokenStorage,
          authorizationClient: mockAuthorizationClient,
          token: const Token('access token', 'refresh token'),
        );

        when(mockAuthorizationClient.isAccessTokenValid(any))
            .thenAnswer((_) => Future.value(false));
        when(mockAuthorizationClient.isRefreshTokenValid(any))
            .thenAnswer((_) => Future.value(true));
        when(mockAuthorizationClient.refresh(any)).thenAnswer(
          (_) => Future.value(
            const Token('new_access_token', 'new_refresh_token'),
          ),
        );

        final response = http.StreamedResponse(
          Stream.value([]),
          401,
          request: http.Request('GET', Uri.parse('https://example.com'))
            ..headers['Authorization'] = 'Bearer access token',
        );

        await authInterceptor.interceptResponse(response, mockResponseHandler);

        verify(
          mockAuthorizationClient.refresh(
            const Token('access token', 'refresh token'),
          ),
        );
      },
    );
  });
}
