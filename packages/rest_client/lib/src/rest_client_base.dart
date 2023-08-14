import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';
import 'package:path/path.dart' as p;
import 'package:rest_client/src/exception/network_exception.dart';
import 'package:rest_client/src/rest_client.dart';

/// {@macro rest_client}
@immutable
class RestClientBase implements RestClient {
  /// {@macro rest_client}
  RestClientBase({
    required String baseUrl,
    http.Client? client,
  })  : _client = client ?? http.Client(),
        _baseUri = Uri.parse(baseUrl);

  final Uri _baseUri;
  final http.Client _client;

  @override
  Future<Map<String, Object?>> get(
    String path, {
    Map<String, Object?>? headers,
    Map<String, Object?>? queryParams,
  }) =>
      _send(
        path,
        method: 'GET',
        headers: headers,
        queryParams: queryParams,
      );

  @override
  Future<Map<String, Object?>> post(
    String path, {
    required Map<String, Object?> body,
    Map<String, Object?>? headers,
    Map<String, Object?>? queryParams,
  }) =>
      _send(
        path,
        method: 'POST',
        headers: headers,
        queryParams: queryParams,
      );

  @override
  Future<Map<String, Object?>> put(
    String path, {
    required Map<String, Object?> body,
    Map<String, Object?>? headers,
    Map<String, Object?>? queryParams,
  }) =>
      _send(
        path,
        method: 'PUT',
        headers: headers,
        queryParams: queryParams,
      );

  @override
  Future<Map<String, Object?>> delete(
    String path, {
    Map<String, Object?>? headers,
    Map<String, Object?>? queryParams,
  }) =>
      _send(
        path,
        method: 'DELETE',
        headers: headers,
        queryParams: queryParams,
      );

  @override
  Future<Map<String, Object?>> patch(
    String path, {
    required Map<String, Object?> body,
    Map<String, Object?>? headers,
    Map<String, Object?>? queryParams,
  }) =>
      _send(
        path,
        method: 'PATCH',
        headers: headers,
        queryParams: queryParams,
      );

  Future<Map<String, Object?>> _send(
    String path, {
    required String method,
    Map<String, Object?>? body,
    Map<String, Object?>? headers,
    Map<String, Object?>? queryParams,
  }) async {
    try {
      final request = buildRequest(
        method: method,
        path: path,
        queryParams: queryParams,
        headers: headers,
        body: body,
      );
      final response =
          await _client.send(request).then(http.Response.fromStream);

      if (response.statusCode > 199 && response.statusCode < 300) {
        return decodeResponse(response);
      } else if (response.statusCode > 499) {
        throw InternalServerException(
          statusCode: response.statusCode,
          message: response.body,
        );
      } else if (response.statusCode > 399) {
        final decoded = jsonDecode(response.body) as Map<String, Object?>?;
        throw RestClientException(
          statusCode: response.statusCode,
          // TODO(starter): Set there your field which
          // server returns in case of error
          message: decoded?['message'] as String?,
        );
      }
      throw UnsupportedError('Unsupported statusCode: ${response.statusCode}');
    } on Object catch (e, stackTrace) {
      Error.throwWithStackTrace(
        RestClientException(message: 'Unsupported error: $e'),
        stackTrace,
      );
    }
  }

  /// Encodes [body] to JSON and then to UTF8
  @protected
  @visibleForTesting
  List<int> encodeBody(
    Map<String, Object?> body,
  ) {
    try {
      return json.fuse(utf8).encode(body);
    } on Object catch (e, stackTrace) {
      Error.throwWithStackTrace(
        RestClientException(message: 'Error occured during encoding body $e'),
        stackTrace,
      );
    }
  }

  /// Decode response body to JSON
  ///
  /// Throws [RestClientException] if response body is not valid JSON
  ///
  /// Throws [NetworkException] if response body is not valid JSON
  ///
  /// This works only if the server sends responses in a unified way
  ///
  /// For example, if the server returns an error,
  /// it should return a JSON object with the key `message`
  ///
  /// ```json
  /// {
  ///  "message": "Error message"
  /// }
  /// ```
  ///
  /// If the server returns a successful response,
  /// it should return a JSON object with the key `data`
  ///
  /// ```json
  /// {
  ///   "data": {
  ///     "id": 1,
  ///     "name": "John Doe"
  ///   }
  /// }
  /// ```
  @protected
  @visibleForTesting
  Map<String, Object?> decodeResponse(http.Response response) {
    final contentType =
        response.headers['content-type'] ?? response.headers['Content-Type'];
    if (contentType?.contains('application/json') ?? false) {
      final body = response.body;
      try {
        final json = jsonDecode(body) as Map<String, Object?>;
        // TODO(starter): Set there your field
        if (json case {'message': final String message}) {
          throw RestClientException(message: message);
        }
        // TODO(starter): Set there your field
        if (json case {'data': final Map<String, Object?> data}) {
          return data;
        }
        throw RestClientException(
          message: 'Server returned invalid json: $json',
        );
      } on Object catch (error, stackTrace) {
        if (error is NetworkException) rethrow;

        final _body = body.length > 100 ? '${body.substring(0, 100)}...' : body;

        Error.throwWithStackTrace(
          InternalServerException(
            message: 'Server returned invalid json: $error',
          ),
          StackTrace.fromString(
            '$stackTrace\n'
            'Body: "$_body"',
          ),
        );
      }
    } else {
      Error.throwWithStackTrace(
        InternalServerException(
          message: 'Server returned invalid content type: $contentType',
          statusCode: response.statusCode,
        ),
        StackTrace.fromString(
          '${StackTrace.current}\n'
          'Headers: "${jsonEncode(response.headers)}"',
        ),
      );
    }
  }

  /// Builds [Uri] from [path] and [queryParams]
  @protected
  @visibleForTesting
  Uri buildUri({
    required String path,
    Map<String, Object?>? queryParams,
  }) {
    final uri = Uri.tryParse(path);
    if (uri == null) return _baseUri;
    final queryParameters = <String, Object?>{
      ..._baseUri.queryParameters,
      ...uri.queryParameters,
      ...?queryParams,
    };
    return _baseUri.replace(
      path: p.normalize(p.join(_baseUri.path, uri.path)),
      queryParameters: queryParameters.isEmpty ? null : queryParameters,
    );
  }

  /// Builds [http.Request] from [method], [path],
  /// [queryParams], [body] and [headers]
  @protected
  @visibleForTesting
  http.Request buildRequest({
    required String method,
    required String path,
    Map<String, Object?>? queryParams,
    Map<String, Object?>? body,
    Map<String, Object?>? headers,
  }) {
    final uri = buildUri(path: path, queryParams: queryParams);
    final request = http.Request(method, uri);
    if (body != null) request.bodyBytes = encodeBody(body);
    request.headers.addAll({
      if (body != null) ...{
        'Content-Type': 'application/json;charset=utf-8',
        'Content-Length': request.bodyBytes.length.toString(),
      },
      'Connection': 'Keep-Alive',
      // the same as `"Cache-Control": "no-cache"`, but deprecated
      // however, to support older servers that tie to HTTP/1.0 this should
      // be included. According to RFC this header can be included and used
      // by the server even if it is HTTP/1.1+
      'Pragma': 'no-cache',
      'Accept': 'application/json',
      ...?headers?.map((key, value) => MapEntry(key, value.toString())),
    });
    return request;
  }
}
