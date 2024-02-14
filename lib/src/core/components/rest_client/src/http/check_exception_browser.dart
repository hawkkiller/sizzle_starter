import 'package:http/http.dart' as http;
import 'package:sizzle_starter/src/core/components/rest_client/rest_client.dart';

/// Checks the [http.ClientException] and tries to parse it.
Object? checkHttpException(http.ClientException e) {
  // TODO(mlazebny): validate this logic, verify that XMLHttpRequest
  // is raised only when there is a problem with connection cause
  // I think that it can be raised in case of CORS as well as other situations
  if (e.message.contains('XMLHttpRequest error')) {
    return ConnectionException(message: e.message, cause: e);
  }

  return null;
}
