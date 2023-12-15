import 'dart:async';

import 'package:async/async.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/subjects.dart';
import 'package:sizzle_starter/src/core/components/rest_client/rest_client.dart';
import 'package:sizzle_starter/src/core/components/rest_client/src/oauth/refresh_client.dart';
import 'package:sizzle_starter/src/core/utils/logger.dart';

// coverage:ignore-start
/// Throw this exception when refresh token fails
class RevokeTokenException implements Exception {
  /// Create a [RevokeTokenException]
  const RevokeTokenException();

  @override
  String toString() => 'RevokedTokenException';
}
// coverage:ignore-end

/// Build headers for the request
typedef HeaderBuilder = Map<String, String> Function(TokenPair pair);

/// [AuthenticationStatus] is used to determine the authentication state
/// of the user.
///
/// This should be consumed by the business logic.
enum AuthenticationStatus {
  /// The initial state of the authentication status
  initial,

  /// The user is authenticated
  authenticated,

  /// The user is unauthenticated
  unauthenticated;
}

/// AuthSource provides valuable information about the authentication state
abstract interface class AuthStatusDataSource {
  /// Get the token pair
  ///
  /// Returns the cached token pair if it exists,
  /// otherwise loads from the storage.
  Future<TokenPair?> getTokenPair();

  /// Stream of token pairs
  ///
  /// This stream should be listened from repository and bloc,
  /// if it emits null, it means the token pair is revoked
  /// and the user should be logged out.
  Stream<AuthenticationStatus> getAuthenticationStatusStream();
}

/// Interceptor for OAuth
///
/// This interceptor adds the OAuth token to the request header
/// and clears the token if the request fails with a 401
class OAuthInterceptor extends QueuedInterceptor
    implements AuthStatusDataSource {
  /// Create an OAuth interceptor
  OAuthInterceptor({
    required this.storage,
    required this.refreshClient,
    @visibleForTesting Dio? retryClient,
  }) : retryClient = retryClient ?? Dio() {
    _storageSubscription = storage.getTokenPairStream().listen(
          _updateAuthenticationStatus,
        );

    // Preload the token pair
    getTokenPair().then(_updateAuthenticationStatus).ignore();
  }

  /// [Dio] client used to retry the request.
  final Dio retryClient;

  /// The token storage
  ///
  /// This is used to store and retrieve the OAuth token.
  final TokenStorage storage;

  /// Refresh client that refreshes the OAuth token pair
  ///
  /// This is used to refresh the OAuth token
  /// pair when the request fails with a 401.
  final RefreshClient refreshClient;

  /// Async cache that ensures that only one request is made to the storage
  /// simultaneously.
  final AsyncCache<TokenPair?> _tokenCache = AsyncCache.ephemeral();

  StreamSubscription<TokenPair?>? _storageSubscription;

  /// The current token pair
  TokenPair? _tokenPair;

  /// The current authentication status
  var _authenticationStatus = AuthenticationStatus.initial;

  /// The authentication status controller
  final _authController = BehaviorSubject.seeded(AuthenticationStatus.initial);

  @override
  Future<TokenPair?> getTokenPair() {
    if (_tokenPair != null) {
      return Future.value(_tokenPair);
    }

    return _tokenCache.fetch(
      () async => _tokenPair = await storage.loadTokenPair(),
    );
  }

  @override
  Stream<AuthenticationStatus> getAuthenticationStatusStream() =>
      _authController.stream;

  /// Clear the token pair
  /// Invalidates cache and clears storage
  @visibleForTesting
  Future<void> clearTokenPair() => storage.clearTokenPair();

  /// Save the token pair
  /// Invalidates cache and saves to storage
  @visibleForTesting
  Future<void> saveTokenPair(TokenPair pair) => storage.saveTokenPair(pair);

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    try {
      // Load the token pair
      final tokenPair = await getTokenPair();

      // Build the headers based on the token pair
      final headers = tokenPair != null
          ? buildHeaders(tokenPair)
          : const <String, String>{};

      // Add the headers to the request
      options.headers.addAll(headers);

      // Continue the request
      handler.next(options);
    } on Object catch (e) {
      logger.warning('Clearing token pair due to error: $e');

      // We don't create a new exception here, just rethrow the original
      rethrow;
    }
  }

  @override
  Future<void> onResponse(
    Response<Object?> response,
    ResponseInterceptorHandler handler,
  ) async {
    final tokenPair = await getTokenPair();

    if (tokenPair == null || !shouldRefresh(response)) {
      return handler.next(response);
    }

    final newResponse = await _refresh(response, tokenPair.refreshToken);
    handler.resolve(newResponse);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final response = err.response;
    final token = await getTokenPair();
    if (response == null ||
        token == null ||
        err.error is RevokeTokenException ||
        !shouldRefresh(response)) {
      return handler.next(err);
    }

    try {
      final refreshResponse = await _refresh(response, token.refreshToken);
      handler.resolve(refreshResponse);
    } on DioException catch (error) {
      handler.next(error);
    }
  }

  // coverage:ignore-start
  /// Close the interceptor
  Future<void> close() async {
    await _storageSubscription?.cancel();
    await _authController.close();
  }
  // coverage:ignore-end

  /// Build the headers
  ///
  /// This is used to build the headers for the request.
  @visibleForTesting
  @pragma('vm:prefer-inline')
  Map<String, String> buildHeaders(TokenPair pair) => {
        'Authorization': 'Bearer ${pair.accessToken}',
      };

  /// Check if the token pair should be refreshed
  @visibleForTesting
  @pragma('vm:prefer-inline')
  bool shouldRefresh<T>(Response<T> response) => response.statusCode == 401;

  /// Update the authentication status based on the token pair
  void _updateAuthenticationStatus(TokenPair? token) {
    final oldStatus = _authenticationStatus;
    if (token == null) {
      _authenticationStatus = AuthenticationStatus.unauthenticated;
    } else {
      _authenticationStatus = AuthenticationStatus.authenticated;
    }

    _tokenPair = token;
    if (oldStatus != _authenticationStatus) {
      _authController.add(_authenticationStatus);
    }
  }

  Future<Response<T>> _refresh<T>(Response<T> response, String refresh) async {
    final TokenPair newTokenPair;

    try {
      // Refresh the token pair
      newTokenPair = await refreshClient.refreshToken(refresh);
    } on RevokeTokenException {
      // Clear the token pair
      logger.info('Revoking token pair');
      await clearTokenPair();
      rethrow;
    } on Object catch (_) {
      rethrow;
    }

    // Save the new token pair
    await saveTokenPair(newTokenPair);

    final headers = buildHeaders(newTokenPair);

    // Retry the request
    final newResponse = await retryRequest<T>(response, headers);

    return newResponse;
  }

  /// Retry the request
  @visibleForTesting
  Future<Response<T>> retryRequest<T>(
    Response<T> response,
    Map<String, String> headers,
  ) =>
      retryClient.request<T>(
        response.requestOptions.path,
        cancelToken: response.requestOptions.cancelToken,
        data: response.requestOptions.data,
        onReceiveProgress: response.requestOptions.onReceiveProgress,
        onSendProgress: response.requestOptions.onSendProgress,
        queryParameters: response.requestOptions.queryParameters,
        options: Options(
          method: response.requestOptions.method,
          sendTimeout: response.requestOptions.sendTimeout,
          receiveTimeout: response.requestOptions.receiveTimeout,
          extra: response.requestOptions.extra,
          headers: response.requestOptions.headers..addAll(headers),
          responseType: response.requestOptions.responseType,
          contentType: response.requestOptions.contentType,
          validateStatus: response.requestOptions.validateStatus,
          receiveDataWhenStatusError:
              response.requestOptions.receiveDataWhenStatusError,
          followRedirects: response.requestOptions.followRedirects,
          maxRedirects: response.requestOptions.maxRedirects,
          requestEncoder: response.requestOptions.requestEncoder,
          responseDecoder: response.requestOptions.responseDecoder,
          listFormat: response.requestOptions.listFormat,
        ),
      );
}
