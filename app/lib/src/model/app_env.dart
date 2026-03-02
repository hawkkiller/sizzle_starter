/// The environment.
enum AppEnv {
  /// Development environment.
  dev._('dev'),

  /// Production environment.
  prod._('prod')
  ;

  /// The environment value.
  final String value;

  const AppEnv._(this.value);

  /// Returns the environment from the given [value].
  ///
  /// If the value is not found, the default environment is returned.
  static AppEnv from(String? value) => AppEnv.values.firstWhere(
    (e) => e.value.toLowerCase() == value?.toLowerCase(),
    orElse: () => AppEnv.dev,
  );
}
