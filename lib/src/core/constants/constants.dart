class Constants {
  static String baseUrl = '$hostUrl/api';

  static String get hostUrl => switch (const String.fromEnvironment('STAGE').toLowerCase()) {
    'test' => 'https://goldfish-app-3lf7u.ondigitalocean.app',
    _ => 'https://example.com',
  };
}
