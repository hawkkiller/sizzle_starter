import 'package:meta/meta.dart';

/// {@template network_exception}
/// Base class for all network exceptions
/// {@endtemplate}
@immutable
abstract class NetworkException implements Exception {}

/// {@template rest_client_exception}
/// If something went wrong on the client side
/// {@endtemplate}
base class RestClientException implements NetworkException {
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

/// {@template wrong_response_type_exception}
/// If the response type is not supported
/// {@endtemplate}
final class WrongResponseTypeException extends RestClientException {
  /// {@macro wrong_response_type_exception}
  const WrongResponseTypeException({
    super.message,
    super.statusCode,
  });

  @override
  String toString() => 'WrongResponseTypeException('
      'message: $message,'
      'statusCode: $statusCode'
      ')';
}

/// {@template connection_exception}
/// If there is no internet connection
/// {@endtemplate}
final class ConnectionException extends RestClientException {
  /// {@macro connection_exception}
  const ConnectionException({
    super.message,
    super.statusCode,
  });

  @override
  String toString() => 'NoInternetException('
      'message: $message,'
      'statusCode: $statusCode'
      ')';
}

/// {@template internal_server_exception}
/// If something went wrong on the server side
/// {@endtemplate}
base class InternalServerException implements NetworkException {
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

/// {@template unauthorized_exception}
/// If the user is not authorized to make the request [401]
/// {@endtemplate}
final class UnauthorizedException extends RestClientException {
  /// {@macro unauthorized_exception}
  const UnauthorizedException({
    super.message,
  }) : super(statusCode: 401);

  @override
  String toString() => 'UnauthorizedException('
      'message: $message,'
      'statusCode: $statusCode'
      ')';
}
