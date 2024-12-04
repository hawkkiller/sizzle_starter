import 'dart:async';

/// [TokenStorage] stores and manages the Auth token.
abstract interface class TokenStorage<T> {
  /// Load the Auth token from the storage.
  ///
  /// If this returns null, the client should assume that the user is not
  /// authenticated.
  Future<T?> load();

  /// Save the Auth token to the storage.
  ///
  /// This is used to persist the token pair after:
  ///  - A successful sign-in
  ///  - A successful token refresh
  ///
  /// Note, that this method should not be called when user logs out -
  /// use [clear] for that.
  Future<void> save(T tokenPair);

  /// Clears the Auth token.
  ///
  /// This can be used to clear the token pair, for example, when the user logs
  /// out or token pair is revoked / expired.
  Future<void> clear();

  /// Returns a stream of the Auth token.
  ///
  /// Every time the Auth token changes, the new value will be added to the
  /// stream.
  ///
  /// This is especially useful as [TokenStorage] can be used from
  /// different places and the token can be changed from any of them.
  /// For example, when user logs out, we need to update the value in
  /// the interceptor as well as in the bloc that holds the authentication
  /// state.
  Stream<T?> getStream();

  /// Closes the storage.
  ///
  /// After this method is called, the storage should not be used anymore.
  Future<void> close();
}
