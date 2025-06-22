import 'package:cronet_http/cronet_http.dart' show CronetClient;
import 'package:cupertino_http/cupertino_http.dart' show CupertinoClient;
import 'package:flutter/foundation.dart' show TargetPlatform, defaultTargetPlatform;
import 'package:http/http.dart' as http;

/// Creates an [http.Client] based on the current platform.
///
/// For Android, it returns a [CronetClient] with the default Cronet engine.
/// For iOS and macOS, it returns a [CupertinoClient]
/// with the default session configuration.
http.Client? createCustomClient() {
  return switch (defaultTargetPlatform) {
    TargetPlatform.android => CronetClient.defaultCronetEngine(),
    TargetPlatform.iOS || TargetPlatform.macOS => CupertinoClient.defaultSessionConfiguration(),
    _ => null,
  };
}
