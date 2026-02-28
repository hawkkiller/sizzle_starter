import 'dart:async';
import 'dart:convert';

import 'package:common_rest_client/src/exception/rest_client_exception.dart';
import 'package:common_rest_client/src/interceptor/rest_client_interceptor.dart';
import 'package:common_rest_client/src/rest_client.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;

/// {@macro rest_client}
@immutable
abstract base class RestClientBase implements RestClient {
  /// {@macro rest_client}
  RestClientBase({
    required String baseUrl,
    List<RestClientInterceptor>? interceptors,
  }) : baseUri = Uri.parse(baseUrl),
       _interceptors = interceptors ?? const [];

  /// The base url for the client
  final Uri baseUri;

  /// List of interceptors to process requests and responses.
  ///
  /// Interceptors are called in order for requests (first to last),
  /// and in reverse order for responses and errors (last to first).
  final List<RestClientInterceptor> _interceptors;

  static final _jsonUTF8 = json.fuse(utf8);

  /// Sends a request to the server.
  ///
  /// This method should be implemented by subclasses to perform the actual
  /// HTTP request. It receives the request after all interceptors have
  /// processed it.
  @protected
  Future<RestClientResponse> sendRequest(RestClientRequest request);

  /// Sends a request through the interceptor chain.
  Future<Map<String, Object?>?> send({
    required String path,
    required String method,
    Map<String, Object?>? body,
    Map<String, String>? headers,
    Map<String, String?>? queryParams,
  }) async {
    // Build initial request
    var request = RestClientRequest(
      uri: buildUri(path: path, queryParams: queryParams),
      method: method,
      body: body,
      headers: headers ?? {},
    );

    // Run onRequest interceptors (first to last)
    for (final interceptor in _interceptors) {
      request = await interceptor.onRequest(request);
    }

    try {
      // Send the actual request
      var response = await sendRequest(request);

      // Run onResponse interceptors (last to first)
      for (final interceptor in _interceptors.reversed) {
        response = await interceptor.onResponse(response);
      }

      return response.data;
    } catch (error, stackTrace) {
      // Run onError interceptors (last to first)
      for (final interceptor in _interceptors.reversed) {
        try {
          final response = await interceptor.onError(error, stackTrace, request);
          return response.data;
        } catch (newError, newStackTrace) {
          // If the interceptor rethrew the same error, continue to the next one.
          // If it threw something new (likely a bug), let it propagate.
          if (identical(newError, error)) continue;
          Error.throwWithStackTrace(newError, newStackTrace);
        }
      }

      rethrow;
    }
  }

  @override
  Future<Map<String, Object?>?> delete(
    String path, {
    Map<String, String>? headers,
    Map<String, String?>? queryParams,
  }) => send(path: path, method: 'DELETE', headers: headers, queryParams: queryParams);

  @override
  Future<Map<String, Object?>?> get(
    String path, {
    Map<String, String>? headers,
    Map<String, String?>? queryParams,
  }) => send(path: path, method: 'GET', headers: headers, queryParams: queryParams);

  @override
  Future<Map<String, Object?>?> patch(
    String path, {
    required Map<String, Object?> body,
    Map<String, String>? headers,
    Map<String, String?>? queryParams,
  }) => send(path: path, method: 'PATCH', body: body, headers: headers, queryParams: queryParams);

  @override
  Future<Map<String, Object?>?> post(
    String path, {
    required Map<String, Object?> body,
    Map<String, String>? headers,
    Map<String, String?>? queryParams,
  }) => send(path: path, method: 'POST', body: body, headers: headers, queryParams: queryParams);

  @override
  Future<Map<String, Object?>?> put(
    String path, {
    required Map<String, Object?> body,
    Map<String, String>? headers,
    Map<String, String?>? queryParams,
  }) => send(path: path, method: 'PUT', body: body, headers: headers, queryParams: queryParams);

  /// Encodes [body] to JSON and then to UTF8
  @protected
  @visibleForTesting
  List<int> encodeBody(Map<String, Object?> body) => _jsonUTF8.encode(body);

  /// Builds [Uri] from [path], [queryParams] and [baseUri]
  @protected
  @visibleForTesting
  Uri buildUri({required String path, Map<String, String?>? queryParams}) {
    final finalPath = p.join(baseUri.path, path);
    return baseUri.replace(
      path: finalPath,
      queryParameters: {...baseUri.queryParameters, ...?queryParams},
    );
  }

  /// Decodes the response [body]
  ///
  /// This method decodes the response body to a map.
  @protected
  @visibleForTesting
  Future<Map<String, Object?>?> decodeResponse(
    List<int> body, {
    required int statusCode,
  }) async {
    try {
      if (body.isEmpty) return null;

      // If the body is too large, decode it in a separate isolate
      // 32 KB is a reasonable threshold for offloading JSON decoding to an isolate.
      if (body.length > 1024 * 32) {
        final decodedJson = await compute(
          _jsonUTF8.decode,
          body,
          debugLabel: kDebugMode ? 'Decode Bytes Compute' : null,
        );

        return decodedJson as Map<String, Object?>?;
      }

      return _jsonUTF8.decode(body)! as Map<String, Object?>;
    } catch (e, stackTrace) {
      Error.throwWithStackTrace(
        UnexpectedResponseException(statusCode: statusCode, cause: e),
        stackTrace,
      );
    }
  }
}
