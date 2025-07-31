// ignore_for_file: avoid-unnecessary-reassignment

import 'dart:async';

import 'package:rest_client/rest_client.dart';

abstract interface class RestClientInterceptor {
  /// Intercepts a [RestRequest] before it is sent.
  Future<RestRequest> interceptRequest(RestRequest request);

  /// Intercepts a [RestResponse] after it is received.
  Future<RestResponse> interceptResponse(RestResponse response);

  /// Intercepts an error that occurs during the request.
  Future<void> interceptError(Object error, StackTrace stackTrace);
}

mixin QueuedOperations {
  final Map<String, Future<Object?>> _queues = {};

  /// Runs an operation in a named queue, ensuring sequential execution
  Future<T> runQueued<T>(String queueName, Future<T> Function() operation) {
    final previousOperation = _queues[queueName] ?? Future.value();
    var newOperation = previousOperation.then((_) => operation());

    newOperation = newOperation.whenComplete(() {
      if (_queues[queueName] == newOperation) {
        _queues.remove(queueName);
      }
    });

    // Update the queue with the new operation
    _queues[queueName] = newOperation;

    return newOperation;
  }
}
