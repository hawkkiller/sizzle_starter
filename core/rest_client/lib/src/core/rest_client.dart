import 'package:rest_client/rest_client.dart';

abstract interface class RestClient {
  Future<RestResponse> send(RestRequest request);
  Future<RestResponse> sendMultipart(RestRequestMultipart request);
}
