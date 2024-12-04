import 'dart:async';

/// The client that refreshes the Auth token using the refresh token.
abstract interface class AuthorizationClient<T> {
  /// Check if refresh token is valid
  Future<bool> isRefreshTokenValid(T token);

  /// Check if access token is valid
  Future<bool> isAccessTokenValid(T token);

  /// Refreshes the token.
  ///
  /// This method should throw the [RevokeTokenException] if token
  /// cannot be refreshed.
  Future<T> refresh(T token);
}

// coverage-ignore:start
/// {@template revoke_token_exception}
/// Revoke token exception
///
/// This exception is thrown when the token is not valid and cannot be refreshed
/// {@endtemplate}
class RevokeTokenException implements Exception {
  /// Create a [RevokeTokenException]
  const RevokeTokenException(this.message);

  /// The message of the exception
  final String message;

  @override
  String toString() => 'RevokeTokenException: $message';
}
// coverage-ignore:end
