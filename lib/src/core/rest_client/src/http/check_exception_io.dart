import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:sizzle_starter/src/core/rest_client/rest_client.dart';

// coverage:ignore-start
/// Checks the [http.ClientException] and tries to parse it.
Object? checkHttpException(http.ClientException e) => switch (e) {
      // Under the hood, HTTP has _ClientSocketException that implements
      // SocketException interface and extends ClientException
      final SocketException e => ConnectionException(
          message: e.message,
          cause: e,
        ),
      _ => null,
    };
// coverage:ignore-end
