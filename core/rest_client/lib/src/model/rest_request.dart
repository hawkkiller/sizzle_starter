import 'package:http_parser/http_parser.dart';

sealed class RestRequest {
  const RestRequest({required this.url, required this.method, this.headers});

  final Uri url;
  final String method;
  final Map<String, String>? headers;
}

final class RestRequestBasic extends RestRequest {
  const RestRequestBasic({
    required super.url,
    required super.method,
    super.headers,
    this.body,
  });

  final Object? body;

  @override
  String toString() {
    return 'RestRequestBasic(url: $url, method: $method, headers: $headers, body: $body)';
  }
}

final class RestRequestMultipart extends RestRequest {
  const RestRequestMultipart({
    required super.url,
    required super.method,
    super.headers,
    this.fields = const {},
    this.files = const [],
  });

  final Map<String, String> fields;
  final List<RestMultipartFile> files;

  @override
  String toString() {
    return 'RestRequestMultipart(url: $url, method: $method, headers: $headers, files: $files)';
  }
}

class RestMultipartFile {
  /// Creates a new [RestMultipartFile] from a chunked [Stream] of bytes.
  ///
  /// [contentType] currently defaults to `application/octet-stream`, but in the
  /// future may be inferred from [filename].
  RestMultipartFile(
    this.field,
    this.stream,
    this.length, {
    this.filename,
    MediaType? contentType,
  }) : contentType = contentType ?? MediaType('application', 'octet-stream');

  /// The stream that will emit the file's contents.
  final Stream<List<int>> stream;

  /// The name of the form field for the file.
  final String field;

  /// The size of the file in bytes.
  ///
  /// This must be known in advance, even if this file is created from a
  /// [Stream<List<int>>].
  final int length;

  /// The basename of the file.
  ///
  /// May be `null`.
  final String? filename;

  /// The content-type of the file.
  ///
  /// Defaults to `application/octet-stream`.
  final MediaType contentType;

  @override
  String toString() {
    return 'RestMultipartFile(field: $field, length: $length, filename: $filename, contentType: $contentType)';
  }
}
