import 'package:common_rest_client/common_rest_client.dart';
import 'package:http/http.dart' as http;

// coverage:ignore-start
/// Checks the [http.ClientException] and tries to parse it.
Object? checkHttpException(http.ClientException e) {
  if (e.message.contains('XMLHttpRequest error')) {
    return NetworkException(message: e.message, cause: e);
  }

  return null;
}

// coverage:ignore-end
