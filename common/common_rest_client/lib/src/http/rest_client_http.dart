import 'dart:async';

import 'package:common_rest_client/src/exception/rest_client_exception.dart';
import 'package:common_rest_client/src/interceptor/rest_client_interceptor.dart';
import 'package:common_rest_client/src/rest_client_base.dart';
import 'package:http/http.dart' as http;

http.Client createDefaultHttpClient() {
  return http.Client();
}

/// {@template rest_client_http}
/// Rest client that uses [http] for making requests.
/// {@endtemplate}
final class RestClientHttp extends RestClientBase {
  /// {@macro rest_client_http}
  ///
  /// The [client] is optional and defaults to [http.Client]
  ///
  /// If you provide a [client], you are responsible for closing it.
  ///
  /// The [interceptors] are called in order for requests (first to last),
  /// and in reverse order for responses and errors (last to first).
  ///
  /// ```dart
  /// final client = http.Client();
  ///
  /// final restClient = RestClientHttp(
  ///   baseUrl: 'https://example.com',
  ///   client: client,
  ///   interceptors: [
  ///     LoggingInterceptor(),
  ///     AuthInterceptor(() => authService.getToken()),
  ///   ],
  /// );
  /// ```
  RestClientHttp({
    required super.baseUrl,
    super.interceptors,
    http.Client? client,
  }) : _client = client ?? http.Client();

  final http.Client _client;

  @override
  Future<RestClientResponse> sendRequest(RestClientRequest request) async {
    try {
      final httpRequest = http.Request(request.method, request.uri);
      httpRequest.headers.addAll(request.headers);

      if (request.body != null) {
        httpRequest.bodyBytes = encodeBody(request.body!);
        httpRequest.headers['content-type'] = 'application/json;charset=utf-8';
      }

      final response = await _client.send(httpRequest).then(http.Response.fromStream);

      final data = await decodeResponse(
        response.bodyBytes,
        statusCode: response.statusCode,
      );

      return RestClientResponse(
        statusCode: response.statusCode,
        data: data,
        request: request,
        headers: response.headers,
      );
    } on RestClientException {
      rethrow;
    } on http.ClientException catch (e, stack) {
      Error.throwWithStackTrace(NetworkException(message: e.message), stack);
    }
  }
}
