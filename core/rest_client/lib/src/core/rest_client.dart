import 'package:rest_client/rest_client.dart';
import 'package:rest_client/src/model/rest_request.dart';
import 'package:rest_client/src/model/rest_request_multipart.dart';

abstract interface class RestClient {
  Future<RestResponse> send(RestRequest request);
  Future<RestResponse> sendMultipart(RestRequestMultipart request);
}
