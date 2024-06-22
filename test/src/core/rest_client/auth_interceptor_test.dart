import 'package:flutter_test/flutter_test.dart';
import 'package:intercepted_client/intercepted_client.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:sizzle_starter/src/core/rest_client/src/auth/auth_interceptor.dart';
import 'package:http/http.dart' as http;

import 'package:sizzle_starter/src/core/rest_client/src/auth/authorization_client.dart';
import 'package:sizzle_starter/src/core/rest_client/src/auth/token_storage.dart';
@GenerateNiceMocks([
  MockSpec<AuthorizationClient<Token>>(),
  MockSpec<TokenStorage<Token>>(),
  MockSpec<RequestHandler>(),
])
import 'auth_interceptor_test.mocks.dart';

void main() {
  group('Auth Interceptor', () {
    late MockAuthorizationClient mockAuthorizationClient;
    late MockTokenStorage mockTokenStorage;
    late MockRequestHandler mockRequestHandler;

    setUp(() {
      mockAuthorizationClient = MockAuthorizationClient();
      mockTokenStorage = MockTokenStorage();
      mockRequestHandler = MockRequestHandler();
    });

    tearDown(() {
      reset(mockAuthorizationClient);
      reset(mockTokenStorage);
      reset(mockRequestHandler);
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

      when(mockAuthorizationClient.isAccessTokenValid(any))
          .thenAnswer((_) => Future.value(true));

      final request = http.Request('GET', Uri.parse('https://example.com'));

      await authInterceptor.interceptRequest(request, mockRequestHandler);

      expect(
        request.headers['Authorization'],
        matches('Bearer access_token'),
      );
    });

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
  });
}
