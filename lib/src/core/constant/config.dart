import 'package:sizzle_starter/src/feature/initialization/model/environment.dart';

/// Application configuration
sealed class Config {
  /// Application environment
  static Environment get environment {
    var environment = const String.fromEnvironment('ENVIRONMENT');

    if (environment.isNotEmpty) {
      return Environment.from(environment);
    }

    environment = const String.fromEnvironment('FLUTTER_APP_FLAVOR');

    return Environment.from(environment);
  }

  /// Sentry dsn
  static const String sentryDsn = String.fromEnvironment('SENTRY_DSN');

  /// If [sentryDsn] is not empty, then Sentry should be enabled.
  static bool get enableSentry => sentryDsn.isNotEmpty;

  /// Max screen layout width for screen with list view.
  static const int maxScreenLayoutWidth = int.fromEnvironment(
    'MAX_SCREEN_LAYOUT_WIDTH',
    defaultValue: 768,
  );
}
