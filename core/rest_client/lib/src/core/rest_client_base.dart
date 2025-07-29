import 'package:rest_client/rest_client.dart';
import 'package:rest_client/src/core/rest_client.dart';
import 'package:rest_client/src/model/rest_request.dart';

abstract base class RestClientBase implements RestClient {
  Future<RestResponse> get(String url, {Map<String, String>? headers}) {
    return send(RestRequest(url: Uri.parse(url), headers: headers, method: 'GET'));
  }

  Future<RestResponse> post(String url, {Object? body, Map<String, String>? headers}) {
    return send(RestRequest(url: Uri.parse(url), body: body, headers: headers, method: 'POST'));
  }

  Future<RestResponse> put(String url, {Object? body, Map<String, String>? headers}) {
    return send(RestRequest(url: Uri.parse(url), body: body, headers: headers, method: 'PUT'));
  }

  Future<RestResponse> delete(String url, {Map<String, String>? headers}) {
    return send(RestRequest(url: Uri.parse(url), headers: headers, method: 'DELETE'));
  }

  Future<RestResponse> patch(String url, {Object? body, Map<String, String>? headers}) {
    return send(RestRequest(url: Uri.parse(url), body: body, headers: headers, method: 'PATCH'));
  }

  Future<RestResponse> head(String url, {Map<String, String>? headers}) {
    return send(RestRequest(url: Uri.parse(url), headers: headers, method: 'HEAD'));
  }
}
