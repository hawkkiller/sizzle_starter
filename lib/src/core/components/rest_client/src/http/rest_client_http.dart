import 'package:http/http.dart' as http;
import 'package:sizzle_starter/src/core/components/rest_client/rest_client.dart';

import 'package:sizzle_starter/src/core/components/rest_client/src/http/check_exception_io.dart'
    if (dart.library.html) 'package:sizzle_starter/src/core/components/rest_client/src/http/check_exception_browser.dart';

/// {@template rest_client_http}
/// Rest client that uses [http] as HTTP library.
/// {@endtemplate}
final class RestClientHTTP extends RestClientBase {
  final http.Client _client;

  /// {@macro rest_client_http}
  ///
  /// The [client] is optional and defaults to [http.Client]
  ///
  /// If you provide a [client], you are responsible for closing it.
  ///
  /// ```dart
  /// final client = http.Client();
  ///
  /// final restClient = RestClientHTTP(
  ///  baseUrl: 'https://example.com',
  ///  client: client,
  /// );
  /// ```
  RestClientHTTP({required super.baseUrl, http.Client? client})
      : _client = client ?? http.Client();

  @override
  Future<Map<String, Object?>?> send({
    required String path,
    required String method,
    Map<String, Object?>? body,
    Map<String, Object?>? headers,
    Map<String, Object?>? queryParams,
  }) async {
    try {
      final uri = buildUri(path: path, queryParams: queryParams);
      final request = http.Request(method, uri);

      if (body != null) {
        request.bodyBytes = encodeBody(body);
        request.headers['content-type'] = 'application/json;charset=utf-8';
      }

      if (headers != null) {
        request.headers.addAll(
          headers.map((key, value) => MapEntry(key, value.toString())),
        );
      }

      final response = await _client.send(request).then(
            http.Response.fromStream,
          );

      final result = await decodeResponse(
        response.bodyBytes,
        statusCode: response.statusCode,
      );

      return result;
    } on RestClientException {
      rethrow;
    } on http.ClientException catch (e, stack) {
      final checkedException = checkHttpException(e);

      if (checkedException != null) {
        Error.throwWithStackTrace(checkedException, stack);
      }

      Error.throwWithStackTrace(
        ClientException(message: e.message, cause: e),
        stack,
      );
    }
  }
}
