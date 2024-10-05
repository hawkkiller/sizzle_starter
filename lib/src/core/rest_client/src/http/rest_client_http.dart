import 'package:cronet_http/cronet_http.dart' show CronetClient;
import 'package:cupertino_http/cupertino_http.dart' show CupertinoClient;
import 'package:flutter/foundation.dart' show TargetPlatform, defaultTargetPlatform;
import 'package:http/http.dart' as http;
import 'package:sizzle_starter/src/core/rest_client/rest_client.dart';
import 'package:sizzle_starter/src/core/rest_client/src/http/check_exception_io.dart'
    if (dart.library.js_interop) 'package:sizzle_starter/src/core/rest_client/src/http/check_exception_browser.dart';
import 'package:sizzle_starter/src/core/utils/refined_logger.dart';

// coverage:ignore-start
/// Creates an [http.Client] based on the current platform.
///
/// For Android, it returns a [CronetClient] with the default Cronet engine.
/// For iOS and macOS, it returns a [CupertinoClient]
/// with the default session configuration.
http.Client createDefaultHttpClient() {
  http.Client? client;
  final platform = defaultTargetPlatform;

  try {
    client = switch (platform) {
      TargetPlatform.android => CronetClient.defaultCronetEngine(),
      TargetPlatform.iOS || TargetPlatform.macOS => CupertinoClient.defaultSessionConfiguration(),
      _ => null,
    };
  } on Object catch (e, stackTrace) {
    logger.warn(
      'Failed to create a default http client for platform $platform',
      error: e,
      stackTrace: stackTrace,
    );
  }

  return client ?? http.Client();
}
// coverage:ignore-end

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
  /// ```dart
  /// final client = http.Client();
  ///
  /// final restClient = RestClientHTTP(
  ///  baseUrl: 'https://example.com',
  ///  client: client,
  /// );
  /// ```
  RestClientHttp({required super.baseUrl, http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  @override
  Future<Map<String, Object?>?> send({
    required String path,
    required String method,
    Map<String, String?>? queryParams,
    Map<String, String>? headers,
    Map<String, Object?>? body,
  }) async {
    try {
      final uri = buildUri(path: path, queryParams: queryParams);
      final request = http.Request(method, uri);

      if (body != null) {
        request.bodyBytes = encodeBody(body);
        request.headers['content-type'] = 'application/json;charset=utf-8';
      }

      if (headers != null) {
        request.headers.addAll(headers);
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
