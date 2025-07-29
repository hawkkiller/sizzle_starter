import 'package:http_parser/http_parser.dart';

class RestRequestMultipart {
  const RestRequestMultipart({
    required this.url,
    required this.method,
    this.body,
    this.headers,
    this.files,
  });

  final Uri url;
  final String method;
  final Map<String, String>? headers;
  final Object? body;
  final List<RestMultipartFile>? files;

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
