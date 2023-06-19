import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';
import 'package:path/path.dart' as p;
import 'package:rest_client/src/exception/network_exception.dart';
import 'package:rest_client/src/rest_client.dart';

@immutable
class RestClientBase implements RestClient {
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
          // TODO(starter): Set there your field which server returns in case of error
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

  @protected
  @visibleForTesting
  List<int> encodeBody(
    Map<String, Object?> body,
  ) {
    try {
      return utf8.encode(json.encode(body));
    } on Object catch (e, stackTrace) {
      Error.throwWithStackTrace(
        RestClientException(message: 'Error occured during encoding body $e'),
        stackTrace,
      );
    }
  }

  @protected
  @visibleForTesting
  Map<String, Object?> decodeResponse(http.Response response) {
    final contentType =
        response.headers['content-type'] ?? response.headers['Content-Type'];
    if (contentType?.contains('application/json') ?? false) {
      final body = response.body;
      try {
        final json = jsonDecode(body) as Map<String, Object?>;
        // TODO(starter): Set there your field which server returns in case of error
        if (json['message'] != null) {
          throw RestClientException(message: json['message'].toString());
        }
        // TODO(starter): Set there your field which server returns in case of success
        return json['data']! as Map<String, Object?>;
      } on Object catch (error, stackTrace) {
        if (error is NetworkException) rethrow;

        Error.throwWithStackTrace(
          InternalServerException(
            message: 'Server returned invalid json: $error',
          ),
          StackTrace.fromString(
            '$stackTrace\n'
            'Body: "${body.length > 100 ? '${body.substring(0, 100)}...' : body}"',
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
