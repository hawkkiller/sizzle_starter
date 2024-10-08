import 'dart:async';

import 'package:http/http.dart';
import 'package:intercepted_client/intercepted_client.dart';
import 'package:sizzle_starter/src/core/rest_client/src/auth/authorization_client.dart';
import 'package:sizzle_starter/src/core/rest_client/src/auth/token_storage.dart';
import 'package:sizzle_starter/src/core/utils/retry_request_mixin.dart';

/// [Token] is a simple class that holds the pair of tokens
class Token {
  /// Create a [Token]
  const Token(this.accessToken, this.refreshToken);

  /// Access token (used to authenticate the user)
  final String accessToken;

  /// Refresh token (used to refresh the access token)
  final String refreshToken;
}

/// Status of the authentication
enum AuthenticationStatus {
  /// Authenticated
  authenticated,

  /// Unauthenticated
  unauthenticated,
}

/// AuthStatusSource is used to get the status of the authentication
abstract interface class AuthStatusSource {
  /// Stream of [AuthenticationStatus]
  Stream<AuthenticationStatus> get authStatus;
}

/// AuthInterceptor is used to add the Auth token to the request header
/// and refreshes or clears the token if the request fails with a 401
class AuthInterceptor extends SequentialHttpInterceptor with RetryRequestMixin {
  /// Create an Auth interceptor
  ///
  /// [token] may be preloaded and passed via constructor
  AuthInterceptor({
    required this.tokenStorage,
    required this.authorizationClient,
    Client? retryClient,
    Token? token,
  })  : retryClient = retryClient ?? Client(),
        _token = token {
    _tokenStorageSubscription = tokenStorage.getStream().listen((newToken) => _token = newToken);
  }

  StreamSubscription<Token?>? _tokenStorageSubscription;

  /// [Client] to retry the request
  final Client retryClient;

  /// [TokenStorage] to store and retrieve the token
  final TokenStorage<Token> tokenStorage;

  /// [AuthorizationClient] to refresh the token
  final AuthorizationClient<Token> authorizationClient;
  Token? _token;

  Token? _loadToken() => _token;

  Map<String, String> _buildHeaders(Token token) => {
        'Authorization': 'Bearer ${token.accessToken}',
      };

  String? _extractTokenFromHeaders(Map<String, String> headers) {
    final authHeader = headers['Authorization'];
    if (authHeader == null || !authHeader.startsWith('Bearer ')) {
      return null;
    }

    return authHeader.substring(7);
  }

  @override
  Future<void> interceptRequest(
    BaseRequest request,
    RequestHandler handler,
  ) async {
    var token = _loadToken();

    // If token is null, then the request is rejected
    if (token == null) {
      return handler.rejectRequest(
        const RevokeTokenException(
          'Token is not valid and cannot be refreshed',
        ),
      );
    }

    // If token is valid, then the request is made with the token
    if (await authorizationClient.isAccessTokenValid(token)) {
      final headers = _buildHeaders(token);
      request.headers.addAll(headers);

      return handler.next(request);
    }

    // If token is not valid and can be refreshed, then the token is refreshed
    if (await authorizationClient.isRefreshTokenValid(token)) {
      try {
        // Even if refresh token seems to be valid from the client side,
        // it may be revoked / banned / deleted on the server side, so
        // the following method can throw the error.
        token = await authorizationClient.refresh(token);
        await tokenStorage.save(token);

        final headers = _buildHeaders(token);
        request.headers.addAll(headers);

        return handler.next(request);
        // If authorization client decides that the token is no longer
        // valid, it throws [RevokeTokenException] and user should be logged out
      } on RevokeTokenException catch (e) {
        // If token cannot be refreshed, then user should be logged out
        await tokenStorage.clear();
        return handler.rejectRequest(e);
        // However, if another error occurs, like internet connection error,
        // then we should not log out the user, but just reject the request
      } on Object catch (e) {
        return handler.rejectRequest(e);
      }
    }

    // If token is not valid and cannot be refreshed,
    // then user should be logged out
    await tokenStorage.clear();
    return handler.rejectRequest(
      const RevokeTokenException('Token is not valid and cannot be refreshed'),
    );
  }

  @override
  Future<void> interceptResponse(
    StreamedResponse response,
    ResponseHandler handler,
  ) async {
    // If response is 401 (Unauthorized), then Access token is expired
    // and, if possible, should be refreshed
    if (response.statusCode != 401) {
      return handler.resolveResponse(response);
    }

    var token = _loadToken();

    // If token is null, then reject the response
    if (token == null) {
      return handler.rejectResponse(
        const RevokeTokenException(
          'Token is not valid and cannot be refreshed',
        ),
      );
    }

    final tokenFromHeaders = _extractTokenFromHeaders(
      response.request?.headers ?? const {},
    );

    // If request does not have the token, then return the response
    if (tokenFromHeaders == null) {
      return handler.resolveResponse(response);
    }

    // If token is the same, refresh the token
    if (tokenFromHeaders == token.accessToken) {
      if (await authorizationClient.isRefreshTokenValid(token)) {
        try {
          // Even if refresh token seems to be valid from the client side,
          // it may be revoked / banned / deleted on the server side, so
          // the following method can throw the error.
          token = await authorizationClient.refresh(token);
          await tokenStorage.save(token);
          // If authorization client decides that the token is no longer
          // valid, it throws [RevokeTokenException] and user should be logged
          // out
        } on RevokeTokenException catch (e) {
          // If token cannot be refreshed, then user should be logged out
          await tokenStorage.clear();
          return handler.rejectResponse(e);
          // However, if another error occurs, like internet connection error,
          // then we should not log out the user, but just reject the response
        } on Object catch (e) {
          return handler.rejectResponse(e);
        }
      } else {
        // If token cannot be refreshed, then user should be logged out
        await tokenStorage.clear();
        return handler.rejectResponse(
          const RevokeTokenException(
            'Token is not valid and cannot be refreshed',
          ),
        );
      }
    }

    // If token is different, then the token is already refreshed
    // and the request should be made again
    final newResponse = await retryRequest(response, retryClient);

    return handler.resolveResponse(newResponse);
  }

  /// Dispose the [AuthInterceptor]
  void dispose() {
    _tokenStorageSubscription?.cancel();
    retryClient.close();
  }
}
