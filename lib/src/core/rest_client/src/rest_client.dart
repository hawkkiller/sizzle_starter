/// {@template rest_client}
/// A REST client for making HTTP requests.
/// {@endtemplate}
abstract interface class RestClient {
  /// Sends a GET request to the given [path].
  Future<Map<String, Object?>?> get(
    String path, {
    Map<String, String>? headers,
    Map<String, String?>? queryParams,
  });

  /// Sends a POST request to the given [path].
  Future<Map<String, Object?>?> post(
    String path, {
    required Map<String, Object?> body,
    Map<String, String>? headers,
    Map<String, String?>? queryParams,
  });

  /// Sends a PUT request to the given [path].
  Future<Map<String, Object?>?> put(
    String path, {
    required Map<String, Object?> body,
    Map<String, String>? headers,
    Map<String, String?>? queryParams,
  });

  /// Sends a DELETE request to the given [path].
  Future<Map<String, Object?>?> delete(
    String path, {
    Map<String, String>? headers,
    Map<String, String?>? queryParams,
  });

  /// Sends a PATCH request to the given [path].
  Future<Map<String, Object?>?> patch(
    String path, {
    required Map<String, Object?> body,
    Map<String, String>? headers,
    Map<String, String?>? queryParams,
  });

  /// Sends multipart request to the given [path].
  Future<Map<String, Object?>?> multipartPost({
    required String path,
    required String method,
    required List<MultipartFile> files,
    Map<String, String>? headers,
    Map<String, String?>? queryParams,
    Map<String, String>? fields,
  });
}

/// A file to be uploaded as part of a MultipartRequest.
class MultipartFile {
  /// Creates a new [MultipartFile] from a byte array.
  const MultipartFile({
    required this.field,
    required this.filename,
    required this.bytes,
  });

  /// The name of the form field for the file.
  final String field;

  /// The basename of the file.
  final String filename;

  /// The content of the file.
  final List<int> bytes;
}
