import 'package:common_rest_client/src/exception/rest_client_exception.dart';
import 'package:common_rest_client/src/interceptor/rest_client_interceptor.dart';
import 'package:flutter/foundation.dart';

/// RFC 7807 compliant backend exception interceptor.
final class BackendExceptionInterceptor extends BaseInterceptor {
  const BackendExceptionInterceptor();

  @override
  Future<RestClientResponse> onResponse(RestClientResponse response) {
    if (response.statusCode >= 200 && response.statusCode < 400) {
      return SynchronousFuture(response);
    }

    final contentType = response.headers?['content-type']?.toLowerCase() ?? '';

    if (contentType.contains('application/problem+json')) {
      final data = Map.of(response.data ?? <String, Object?>{});

      final type = data.remove('type') as String? ?? '/problems/unknown-error';
      final title = data.remove('title') as String? ?? 'Unknown Error';
      final status = data.remove('status') as int? ?? response.statusCode;
      data.remove('detail');
      data.remove('instance');

      throw ApiException(
        type: type,
        message: title,
        statusCode: status,
        extensions: data,
      );
    }

    throw UnexpectedResponseException(
      statusCode: response.statusCode,
      cause: response.data,
    );
  }
}
