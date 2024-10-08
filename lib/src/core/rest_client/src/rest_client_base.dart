import 'dart:async';
import 'dart:convert';
import 'dart:isolate';

import 'package:meta/meta.dart';
import 'package:path/path.dart' as p;
import 'package:sizzle_starter/src/core/rest_client/rest_client.dart';

/// {@macro rest_client}
@immutable
abstract base class RestClientBase implements RestClient {
  /// {@macro rest_client}
  RestClientBase({required String baseUrl}) : baseUri = Uri.parse(baseUrl);

  /// The base url for the client
  final Uri baseUri;

  static final _jsonUTF8 = json.fuse(utf8);

  /// Sends a request to the server
  Future<Map<String, Object?>?> send({
    required String path,
    required String method,
    Map<String, Object?>? body,
    Map<String, String>? headers,
    Map<String, String?>? queryParams,
  });

  @override
  Future<Map<String, Object?>?> delete(
    String path, {
    Map<String, String>? headers,
    Map<String, String?>? queryParams,
  }) =>
      send(
        path: path,
        method: 'DELETE',
        headers: headers,
        queryParams: queryParams,
      );

  @override
  Future<Map<String, Object?>?> get(
    String path, {
    Map<String, String>? headers,
    Map<String, String?>? queryParams,
  }) =>
      send(
        path: path,
        method: 'GET',
        headers: headers,
        queryParams: queryParams,
      );

  @override
  Future<Map<String, Object?>?> patch(
    String path, {
    required Map<String, Object?> body,
    Map<String, String>? headers,
    Map<String, String?>? queryParams,
  }) =>
      send(
        path: path,
        method: 'PATCH',
        body: body,
        headers: headers,
        queryParams: queryParams,
      );

  @override
  Future<Map<String, Object?>?> post(
    String path, {
    required Map<String, Object?> body,
    Map<String, String>? headers,
    Map<String, String?>? queryParams,
  }) =>
      send(
        path: path,
        method: 'POST',
        body: body,
        headers: headers,
        queryParams: queryParams,
      );

  @override
  Future<Map<String, Object?>?> put(
    String path, {
    required Map<String, Object?> body,
    Map<String, String>? headers,
    Map<String, String?>? queryParams,
  }) =>
      send(
        path: path,
        method: 'PUT',
        body: body,
        headers: headers,
        queryParams: queryParams,
      );

  /// Encodes [body] to JSON and then to UTF8
  @protected
  @visibleForTesting
  List<int> encodeBody(Map<String, Object?> body) {
    try {
      return _jsonUTF8.encode(body);
    } on Object catch (e, stackTrace) {
      Error.throwWithStackTrace(
        ClientException(message: 'Error occurred during encoding', cause: e),
        stackTrace,
      );
    }
  }

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
  /// This method decodes the response body to a map and checks if the response
  /// is an error or successful. If the response is an error, it throws a
  /// [StructuredBackendException] with the error details.
  ///
  /// If the response is successful, it returns the data from the response.
  ///
  /// If the response is neither an error nor successful, it returns the decoded
  /// body as is.
  @protected
  @visibleForTesting
  Future<Map<String, Object?>?> decodeResponse(
    /* String, Map<String, Object?>, List<int> */
    Object? body, {
    int? statusCode,
  }) async {
    if (body == null) return null;

    assert(
      body is String || body is Map<String, Object?> || body is List<int>,
      'Unexpected response body type: ${body.runtimeType}',
    );

    try {
      final decodedBody = switch (body) {
        final Map<String, Object?> map => map,
        final String str => await _decodeString(str),
        final List<int> bytes => await _decodeBytes(bytes),
        _ => throw WrongResponseTypeException(
            message: 'Unexpected response body type: ${body.runtimeType}',
            statusCode: statusCode,
          ),
      };

      if (decodedBody case {'error': final Map<String, Object?> error}) {
        throw StructuredBackendException(
          error: error,
          statusCode: statusCode,
        );
      }

      if (decodedBody case {'data': final Map<String, Object?> data}) {
        return data;
      }

      // Simply return decoded body if it is not an error or data
      // This is useful for responses that do not follow the structured response
      // But generally, it is recommended to follow the structured response :)
      return decodedBody;
    } on RestClientException {
      rethrow;
    } on Object catch (e, stackTrace) {
      Error.throwWithStackTrace(
        ClientException(
          message: 'Error occured during decoding',
          statusCode: statusCode,
          cause: e,
        ),
        stackTrace,
      );
    }
  }

  /// Decodes a [String] to a [Map<String, Object?>]
  Future<Map<String, Object?>?> _decodeString(String str) async {
    if (str.isEmpty) return null;

    if (str.length > 1000) {
      return Isolate.run(() => json.decode(str) as Map<String, Object?>);
    }

    return json.decode(str) as Map<String, Object?>;
  }

  /// Decodes a [List<int>] to a [Map<String, Object?>]
  Future<Map<String, Object?>?> _decodeBytes(List<int> bytes) async {
    if (bytes.isEmpty) return null;

    if (bytes.length > 1000) {
      return Isolate.run(
        () => _jsonUTF8.decode(bytes)! as Map<String, Object?>,
      );
    }

    return _jsonUTF8.decode(bytes)! as Map<String, Object?>;
  }
}
