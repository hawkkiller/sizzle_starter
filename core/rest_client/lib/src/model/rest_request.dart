class RestRequest {
  const RestRequest({required this.url, required this.method, this.body, this.headers});

  final Uri url;
  final String method;
  final Map<String, String>? headers;
  final Object? body;

  @override
  String toString() {
    return 'RestRequest(url: $url, method: $method, headers: $headers)';
  }
}
