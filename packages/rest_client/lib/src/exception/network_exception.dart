import 'package:meta/meta.dart';

@immutable
abstract class NetworkException implements Exception {}

@immutable
class RestClientException implements NetworkException {
  const RestClientException({
    this.message,
    this.statusCode,
  });

  final String? message;
  final int? statusCode;

  @override
  String toString() =>
      'RestClientException(message: $message, statusCode: $statusCode)';
}

@immutable
class InternalServerException implements NetworkException {
  const InternalServerException({
    this.message,
    this.statusCode,
  });

  final String? message;
  final int? statusCode;

  @override
  String toString() =>
      'InternalServerErrorException(message: $message, statusCode: $statusCode)';
}
