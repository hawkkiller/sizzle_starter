import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:sizzle_starter/src/core/rest_client/rest_client.dart';

/// {@template rest_client_dio}
/// Rest client that uses [Dio] to send requests
/// {@endtemplate}
final class RestClientDio extends RestClientBase {
  /// {@macro rest_client_dio}
  RestClientDio({
    required super.baseUrl,
    required Dio dio,
  }) : _dio = dio;

  final Dio _dio;

  /// Send [Dio] request
  @protected
  @visibleForTesting
  Future<Map<String, Object?>?> sendRequest({
    required String path,
    required String method,
    Map<String, Object?>? body,
    Map<String, Object?>? headers,
    Map<String, Object?>? queryParams,
  }) async {
    final uri = buildUri(
      path: path,
      queryParams: queryParams,
    );
    final options = Options(
      headers: headers,
      method: method,
      contentType: 'application/json',
    );

    final response = await _dio.request<List<int>>(
      uri.toString(),
      data: body,
      options: options,
    );

    return decodeResponse(response, statusCode: response.statusCode);
  }

  @override
  Future<Map<String, Object?>> delete(
    String path, {
    Map<String, Object?>? headers,
    Map<String, Object?>? queryParams,
  }) async {
    throw UnimplementedError();
  }

  @override
  Future<Map<String, Object?>> get(
    String path, {
    Map<String, Object?>? headers,
    Map<String, Object?>? queryParams,
  }) {
    // TODO: implement get
    throw UnimplementedError();
  }

  @override
  Future<Map<String, Object?>> patch(
    String path, {
    required Map<String, Object?> body,
    Map<String, Object?>? headers,
    Map<String, Object?>? queryParams,
  }) {
    // TODO: implement patch
    throw UnimplementedError();
  }

  @override
  Future<Map<String, Object?>> post(
    String path, {
    required Map<String, Object?> body,
    Map<String, Object?>? headers,
    Map<String, Object?>? queryParams,
  }) {
    // TODO: implement post
    throw UnimplementedError();
  }

  @override
  Future<Map<String, Object?>> put(
    String path, {
    required Map<String, Object?> body,
    Map<String, Object?>? headers,
    Map<String, Object?>? queryParams,
  }) {
    // TODO: implement put
    throw UnimplementedError();
  }
}
