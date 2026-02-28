import 'package:common_rest_client/src/rest_client.dart';
import 'package:meta/meta.dart';

/// {@template rest_client_exception}
/// Base class for all [RestClient] exceptions.
/// {@endtemplate}
@immutable
sealed class RestClientException implements Exception {
  /// {@macro rest_client_exception}
  const RestClientException({required this.message, this.statusCode});

  /// The message of the exception
  final String message;

  /// The status code of the response (if any)
  final int? statusCode;
}

/// {@template api_exception}
/// RFC 7807 API error exception.
///
/// Thrown when server returns 400-599 with a RFC 7807 compliant error response.
/// {@endtemplate}
final class ApiException extends RestClientException {
  /// {@macro api_exception}
  const ApiException({
    required super.message,
    required super.statusCode,
    required this.type,
    this.extensions,
  });

  /// The type of the error
  final String type;

  /// Optional extra properties from the server
  final Map<String, Object?>? extensions;

  @override
  String toString() => 'ApiException(type: $type, message: $message, ext: $extensions)';
}

/// {@template network_exception}
/// [NetworkException] is thrown if response is not returned at all.
///
/// Potential reasons for this:
/// - No internet connection
/// - Host is unreachable
/// {@endtemplate}
final class NetworkException extends RestClientException {
  /// {@macro network_exception}
  const NetworkException({required super.message, super.statusCode});

  @override
  String toString() => 'NetworkException(message: $message)';
}

/// {@template unexpected_response_exception}
/// [UnexpectedResponseException] is thrown when body doesn't match the expected format.
///
/// It can be thrown for any status code.
/// {@endtemplate}
final class UnexpectedResponseException extends RestClientException {
  /// {@macro unexpected_response_exception}
  const UnexpectedResponseException({super.statusCode, this.cause})
    : super(message: 'Unexpected response format');

  /// Optional cause of the exception
  final Object? cause;

  @override
  String toString() => 'UnexpectedResponseException(statusCode: $statusCode, cause: $cause)';
}
