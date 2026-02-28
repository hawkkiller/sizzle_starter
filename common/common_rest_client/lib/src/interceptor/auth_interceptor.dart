import 'package:common_rest_client/src/interceptor/rest_client_interceptor.dart';

/// {@template auth_interceptor}
/// An interceptor that adds an Authorization header to requests.
///
/// RFC 6750 compliant.
/// {@endtemplate}
final class AuthInterceptor extends BaseInterceptor {
  /// {@macro auth_interceptor}
  const AuthInterceptor(this._onLoadToken);

  final Future<String> Function() _onLoadToken;

  @override
  Future<RestClientRequest> onRequest(RestClientRequest request) {
    return _onLoadToken().then(
      (token) => request.copyWith(
        headers: {...request.headers, 'Authorization': 'Bearer $token'},
      ),
    );
  }
}
