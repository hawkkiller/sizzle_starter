/// {@template api_client_exception}
/// An exception thrown by ApiClient.
/// {@endtemplate}
sealed class ApiClientException implements Exception {
  /// {@macro response_body}
  const ApiClientException({
    this.statusCode,
  });

  /// The status code of the response.
  final int? statusCode;
}

/// {@template api_client_internal_exception}
/// Exception thrown when an internal error occurs in the ApiClient.
/// {@endtemplate}
final class ApiClientInternalException extends ApiClientException {
  /// {@macro api_client_internal_exception}
  ApiClientInternalException(
    this.message, {
    this.error,
    super.statusCode,
  });

  /// The error message.
  final String message;

  /// The error object.
  final Object? error;

  @override
  String toString() => 'ApiClientInternalException: $statusCode $message $error';
}

/// {@template api_client_structured_exception}
/// Exception thrown when an error occurs in the ApiClient with a structured error.
/// {@endtemplate}
final class ApiClientStructuredException extends ApiClientException {
  /// {@macro api_client_structured_exception}
  ApiClientStructuredException(
    this.error, {
    super.statusCode,
  });

  /// The error object.
  final Map<String, Object?> error;

  @override
  String toString() => 'ApiClientStructuredException: $statusCode $error';
}
