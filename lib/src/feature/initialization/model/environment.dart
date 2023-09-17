/// Simple enum to represent the environment
enum Environment {
  /// Development environment
  dev('DEV'),

  /// Production environment
  prod('PROD');

  const Environment(this.value);

  /// Creates an [Environment] from a string
  ///
  /// Throws an [ArgumentError] if the string is not a valid environment
  ///
  /// Example:
  ///
  /// ```dart
  /// final env = Environment.fromEnvironment('DEV'); // OK
  /// final env = Environment.fromEnvironment('PROD'); // OK
  /// // Throws an ArgumentError
  /// final env = Environment.fromEnvironment('invalid');
  /// ```
  static Environment fromString(String value) => switch (value) {
        'DEV' => dev,
        'PROD' => prod,
        _ => throw ArgumentError.value(
            value,
            'value',
            'Invalid environment',
          ),
      };

  /// The string representation of the environment
  ///
  /// Example:
  ///
  /// ```dart
  /// final env = Environment.dev;
  /// print(env.value); // 'dev'
  /// ```
  ///
  /// ```dart
  /// final env = Environment.prod;
  /// print(env.value); // 'prod'
  /// ```
  final String value;
}
