import 'package:meta/meta.dart';

/// {@template network_exception}
/// Base class for all network exceptions
/// {@endtemplate}
@immutable
abstract class NetworkException implements Exception {}

/// {@template rest_client_exception}
/// If something went wrong on the client side
/// {@endtemplate}
@immutable
class RestClientException implements NetworkException {
  /// {@macro rest_client_exception}
  const RestClientException({
    this.message,
    this.statusCode,
  });

  /// Possible reason for the exception
  final String? message;

  /// The status code of the response (if any)
  final int? statusCode;

  @override
  String toString() => 'RestClientException('
      'message: $message,'
      'statusCode: $statusCode'
      ')';
}

/// {@template internal_server_exception}
/// If something went wrong on the server side
/// {@endtemplate}
@immutable
class InternalServerException implements NetworkException {
  /// {@macro internal_server_exception}
  const InternalServerException({
    this.message,
    this.statusCode,
  });

  /// Possible reason for the exception
  final String? message;

  /// The status code of the response (if any)
  final int? statusCode;

  @override
  String toString() => 'InternalServerErrorException('
      'message: $message,'
      'statusCode: $statusCode'
      ')';
}
