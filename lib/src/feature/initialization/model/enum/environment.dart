/// Simple enum to represent the environment
enum Environment {
  dev('dev'),
  prod('prod');

  const Environment(this.value);

  /// Creates an [Environment] from a string
  ///
  /// Throws an [ArgumentError] if the string is not a valid environment
  ///
  /// Example:
  ///
  /// ```dart
  /// final env = Environment.fromEnvironment('dev'); // OK
  /// final env = Environment.fromEnvironment('prod'); // OK
  /// // Throws an ArgumentError
  /// final env = Environment.fromEnvironment('invalid');
  /// ```
  static Environment fromEnvironment(String value) {
    if (value == 'dev') {
      return Environment.dev;
    } else if (value == 'prod') {
      return Environment.prod;
    } else {
      throw ArgumentError('Unknown environment: $value');
    }
  }

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
