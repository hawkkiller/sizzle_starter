import 'package:meta/meta.dart';

/// {@template rest_client_request}
/// Represents an HTTP request before it's sent.
/// {@endtemplate}
@immutable
class RestClientRequest {
  /// {@macro rest_client_request}
  const RestClientRequest({
    required this.uri,
    required this.method,
    this.body,
    this.headers = const {},
  });

  /// The request URI
  final Uri uri;

  /// The HTTP method (GET, POST, PUT, DELETE, PATCH)
  final String method;

  /// The request body (if any)
  final Map<String, Object?>? body;

  /// The request headers
  final Map<String, String> headers;

  /// Creates a copy of this request with the given fields replaced.
  RestClientRequest copyWith({
    Uri? uri,
    String? method,
    Map<String, Object?>? body,
    Map<String, String>? headers,
  }) {
    return RestClientRequest(
      uri: uri ?? this.uri,
      method: method ?? this.method,
      body: body ?? this.body,
      headers: headers ?? this.headers,
    );
  }

  @override
  String toString() => 'RestClientRequest(method: $method, uri: $uri)';
}

/// {@template rest_client_response}
/// Represents an HTTP response after it's received.
/// {@endtemplate}
@immutable
class RestClientResponse {
  /// {@macro rest_client_response}
  const RestClientResponse({
    required this.statusCode,
    required this.data,
    required this.request,
    required this.headers,
  });

  /// The HTTP status code
  final int statusCode;

  /// The decoded response data
  final Map<String, Object?>? data;

  /// The original request that produced this response
  final RestClientRequest request;

  /// The response headers
  final Map<String, String>? headers;

  /// Creates a copy of this response with the given fields replaced.
  RestClientResponse copyWith({
    int? statusCode,
    Map<String, Object?>? data,
    RestClientRequest? request,
    Map<String, String>? headers,
  }) {
    return RestClientResponse(
      statusCode: statusCode ?? this.statusCode,
      data: data ?? this.data,
      request: request ?? this.request,
      headers: headers ?? this.headers,
    );
  }

  @override
  String toString() =>
      'RestClientResponse(statusCode: $statusCode, request: $request, headers: $headers)';
}

/// {@template rest_client_interceptor}
/// Intercepts requests and responses in the REST client pipeline.
///
/// Interceptors are called in order for requests (first to last),
/// and in reverse order for responses and errors (last to first).
/// {@endtemplate}
abstract interface class RestClientInterceptor {
  /// Called before a request is sent.
  ///
  /// Return a modified [RestClientRequest] to alter the request,
  /// or return the same request to pass through unchanged.
  Future<RestClientRequest> onRequest(RestClientRequest request);

  /// Called after a response is received successfully.
  ///
  /// Return a modified [RestClientResponse] to alter the response,
  /// or return the same response to pass through unchanged.
  Future<RestClientResponse> onResponse(RestClientResponse response);

  /// Called when an error occurs during the request.
  ///
  /// You can rethrow the error, throw a different error,
  /// or return a [RestClientResponse] to recover from the error.
  Future<RestClientResponse> onError(
    Object error,
    StackTrace stackTrace,
    RestClientRequest request,
  );
}

/// {@template base_interceptor}
/// A base class for interceptors that provides no-op default implementations.
///
/// Extend this class if you only need to override specific methods.
/// {@endtemplate}
abstract class BaseInterceptor implements RestClientInterceptor {
  /// {@macro base_interceptor}
  const BaseInterceptor();

  @override
  Future<RestClientRequest> onRequest(RestClientRequest request) async => request;

  @override
  Future<RestClientResponse> onResponse(RestClientResponse response) async => response;

  @override
  Future<RestClientResponse> onError(
    Object error,
    StackTrace stackTrace,
    RestClientRequest request,
  ) async {
    Error.throwWithStackTrace(error, stackTrace);
  }
}
