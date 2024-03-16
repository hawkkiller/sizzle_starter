// ignore_for_file: avoid-unrelated-type-assertions
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:sizzle_starter/src/core/components/rest_client/rest_client.dart';

/// Checks the [http.ClientException] and tries to parse it.
Object? checkHttpException(http.ClientException e) => switch (e) {
      final SocketException e => ConnectionException(
          message: e.message,
          cause: e,
        ),
      _ => null,
    };
