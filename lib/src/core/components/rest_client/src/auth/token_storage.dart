import 'dart:async';

import 'package:sizzle_starter/src/core/components/rest_client/src/auth/auth_interceptor.dart';

/// The interface for token storage.
///
/// This interface is used by the [AuthInterceptor]
/// to store and retrieve the Auth token pair.
abstract interface class TokenStorage<T> {
  /// Load the Auth token pair.
  Future<T?> loadTokenPair();

  /// Save the Auth token pair.
  Future<void> saveTokenPair(T tokenPair);

  /// Clear the Auth token pair.
  ///
  /// This is used to clear the token pair when the request fails with a 401.
  Future<void> clearTokenPair();

  /// A stream of token pairs.
  Stream<T?> getTokenPairStream();

  /// Close the token storage.
  Future<void> close();
}
