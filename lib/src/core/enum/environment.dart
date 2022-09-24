enum Environment {
  dev('dev'),
  prod('prod');

  const Environment(this.value);

  static Environment fromEnvironment(String value) {
    if (value == 'dev') {
      return Environment.dev;
    } else if (value == 'prod') {
      return Environment.prod;
    } else {
      throw ArgumentError('Unknown environment: $value');
    }
  }

  final String value;
}
