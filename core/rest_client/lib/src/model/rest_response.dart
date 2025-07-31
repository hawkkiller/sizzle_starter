import 'dart:typed_data';

class RestResponse {
  const RestResponse({required this.statusCode, required this.body, required this.headers});

  final int statusCode;
  final Uint8List body;
  final Map<String, String>? headers;

  @override
  String toString() {
    return 'RestResponse(statusCode: $statusCode, body: ${body.lengthInBytes}, headers: $headers)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    return other is RestResponse &&
        other.statusCode == statusCode &&
        other.body == body &&
        other.headers == headers;
  }

  @override
  int get hashCode => Object.hash(runtimeType, statusCode, body, headers);
}
