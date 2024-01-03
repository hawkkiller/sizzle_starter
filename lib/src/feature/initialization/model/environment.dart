import 'package:flutter/foundation.dart';

/// The environment.
enum Environment {
  /// Development environment.
  dev._('DEV'),

  /// Production environment.
  prod._('PROD');

  /// The environment value.
  final String value;

  const Environment._(this.value);

  /// Returns the environment from the given [value].
  static Environment from(String? value) => switch (value) {
        'DEV' => Environment.dev,
        'PROD' => Environment.prod,
        _ => kReleaseMode ? Environment.prod : Environment.dev,
      };
}
