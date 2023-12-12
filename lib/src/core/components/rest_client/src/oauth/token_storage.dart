import 'package:sizzle_starter/src/core/components/rest_client/src/oauth/oauth_interceptor.dart';

/// A pair of OAuth tokens.
///
/// The **accessToken** is used to authenticate the request.
///
/// The **refreshToken** is used to refresh the accessToken.
///
/// See [OAuthInterceptor] for more details.
typedef TokenPair = ({String accessToken, String refreshToken});

/// The interface for token storage.
///
/// This interface is used by the [OAuthInterceptor]
/// to store and retrieve the OAuth token pair.
abstract interface class TokenStorage {
  /// Load the OAuth token pair.
  Future<TokenPair?> loadTokenPair();

  /// Save the OAuth token pair.
  Future<void> saveTokenPair(TokenPair tokenPair);

  /// Clear the OAuth token pair.
  ///
  /// This is used to clear the token pair when the request fails with a 401.
  Future<void> clearTokenPair();
}

/// InMemoryTokenStorage is an in-memory implementation of [TokenStorage].
/// Generally, this should only be used for testing.
class InMemoryTokenStorage implements TokenStorage {
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

  @override
  Future<void> saveTokenPair(TokenPair tokenPair) async {
    _storage['accessToken'] = tokenPair.accessToken;
    _storage['refreshToken'] = tokenPair.refreshToken;
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
  }
}
