import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:sizzle_starter/src/core/components/rest_client/rest_client.dart';
import 'package:sizzle_starter/src/core/components/rest_client/src/oauth/refresh_client.dart';
import 'package:sizzle_starter/src/core/utils/logger.dart';

/// Throw this exception when refresh token fails
class RevokeTokenException implements Exception {
  /// Create a [RevokeTokenException]
  const RevokeTokenException();

  @override
  String toString() => 'RevokedTokenException';
}

/// Build headers for the request
typedef HeaderBuilder = Map<String, String> Function(TokenPair pair);

/// Interceptor for OAuth
///
/// This interceptor adds the OAuth token to the request header
/// and clears the token if the request fails with a 401
class OAuthInterceptor extends QueuedInterceptor {
  /// Create an OAuth interceptor
  OAuthInterceptor({
    required this.storage,
    required this.refreshClient,
    Dio? baseClient,
  }) : _dio = baseClient ?? Dio();

  final Dio _dio;

  /// The token storage
  ///
  /// This is used to store and retrieve the OAuth token.
  final TokenStorage storage;

  /// Refresh client that refreshes the OAuth token pair
  ///
  /// This is used to refresh the OAuth token
  /// pair when the request fails with a 401.
  final RefreshClient refreshClient;

  /// Build the headers
  ///
  /// This is used to build the headers for the request.
  @visibleForTesting
  @pragma('vm:prefer-inline')
  Map<String, String> buildHeaders(TokenPair pair) =>
      {'Authorization': 'Bearer ${pair.accessToken}'};

  /// Check if the token pair should be refreshed
  @visibleForTesting
  @pragma('vm:prefer-inline')
  bool shouldRefreshTokenPair<T>(Response<T> response) =>
      response.statusCode == 401;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    try {
      // Load the token pair
      final tokenPair = await storage.loadTokenPair();

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
    final tokenPair = await storage.loadTokenPair();

    if (tokenPair == null || !shouldRefreshTokenPair(response)) {
      return handler.next(response);
    }

    try {
      final TokenPair newTokenPair;

      try {
        // Refresh the token pair
        newTokenPair = await refreshClient.refresh(tokenPair.refreshToken);
      } on RevokeTokenException {
        // Clear the token pair
        logger.info('Revoking token pair');
        await storage.clearTokenPair();
        rethrow;
      } on Object catch (_) {
        rethrow;
      }

      // Save the new token pair
      await storage.saveTokenPair(newTokenPair);
      final headers = buildHeaders(newTokenPair);

      // Retry the request
      final newResponse = await retryRequest(response, headers);
      handler.resolve(newResponse);
    } on Object catch (e) {
      logger.warning('Clearing token pair due to error: $e');
      await storage.clearTokenPair();
      rethrow;
    }
  }

  /// Retry the request
  @visibleForTesting
  Future<Response<T>> retryRequest<T>(
    Response<T> response,
    Map<String, String> headers,
  ) =>
      _dio.request<T>(
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
