import 'package:sizzle_starter/src/core/components/rest_client/rest_client.dart';

/// The client that refreshes the Auth token using the refresh token.
///
/// This client is used by the [AuthInterceptor] to refresh the Auth token.
abstract interface class RefreshClient<T> {
  /// Refresh the Auth token.
  ///
  /// This method is called by the [AuthInterceptor]
  /// when the request fails with a 401.
  Future<T> refreshToken(T token);
}
