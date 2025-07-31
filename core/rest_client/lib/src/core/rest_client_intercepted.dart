import 'package:rest_client/rest_client.dart';

abstract base class RestClientIntercepted extends RestClientBase {
  @override
  Future<RestResponse> send(RestRequest request) {
    // TODO: implement send
    throw UnimplementedError();
  }

  @override
  Future<RestResponse> sendMultipart(RestRequestMultipart request) {
    // TODO: implement sendMultipart
    throw UnimplementedError();
  }

  /// Sends a [RestRequest] and returns a [RestResponse].
  ///
  /// This method is used by [RestClientIntercepted] to handle requests.
  Future<RestResponse> sendInternal(RestRequest request);

  /// Sends a [RestRequestMultipart] and returns a [RestResponse].
  ///
  /// This method is used by [RestClientIntercepted] to handle multipart requests.
  Future<RestResponse> sendMultipartInternal(RestRequestMultipart request);
}
