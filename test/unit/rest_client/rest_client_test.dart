import 'package:flutter_test/flutter_test.dart';
import 'package:sizzle_starter/src/core/data/rest_client.dart';

void main() {
  group(
    'RestClient >',
    () {
      group('Build URI > ', () {
        late final Uri baseUri;
        setUpAll(
          () => baseUri = Uri.parse('https://example.com'),
        );
        test(
          'should build a valid URI with preceding slash',
          () {
            final uri = RestClient.buildUri(
              baseUri: baseUri,
              path: '/path',
            );
            expect(uri.toString(), 'https://example.com/path');
          },
        );
        test(
          'should build a valid URI without preceding slash',
          () {
            final uri = RestClient.buildUri(
              baseUri: baseUri,
              path: 'path',
            );
            expect(uri.toString(), 'https://example.com/path');
          },
        );
        test(
          'should build a valid URI with query parameters',
          () {
            final uri = RestClient.buildUri(
              baseUri: baseUri,
              path: 'path?pathkey=pathvalue',
              queryParams: {
                'key': 'value',
              },
            );
            expect(
              uri.toString(),
              'https://example.com/path?pathkey=pathvalue&key=value',
            );
          },
        );
      });
      group(
        'Build request',
        () {
          late final Uri baseUri;
          setUpAll(
            () => baseUri = Uri.parse('https://example.com'),
          );
          test(
            'should build a valid GET request',
            () {
              final request = RestClient.buildRequest(
                baseUri: baseUri,
                path: 'path',
                method: 'GET',
                headers: {
                  'key': 'value',
                },
              );
              expect(request.method, 'GET');
              expect(request.url.toString(), 'https://example.com/path');
              expect(request.headers['key'], 'value');
            },
          );
          test(
            'should build a valid POST request',
            () {
              final request = RestClient.buildRequest(
                baseUri: baseUri,
                path: 'path',
                method: 'POST',
                headers: {
                  'key': 'value',
                },
                body: {
                  'bodykey': 'bodyvalue',
                },
              );
              expect(request.method, 'POST');
              expect(request.url.toString(), 'https://example.com/path');
              expect(request.headers['key'], 'value');
              expect(request.body, '{"bodykey":"bodyvalue"}');
            },
          );
          test(
            'should build a valid PUT request',
            () {
              final request = RestClient.buildRequest(
                baseUri: baseUri,
                path: 'path',
                method: 'PUT',
                headers: {
                  'key': 'value',
                },
                body: {
                  'bodykey': 'bodyvalue',
                },
              );
              expect(request.method, 'PUT');
              expect(request.url.toString(), 'https://example.com/path');
              expect(request.headers['key'], 'value');
              expect(request.body, '{"bodykey":"bodyvalue"}');
            },
          );
          test(
            'should build a valid DELETE request',
            () {
              final request = RestClient.buildRequest(
                baseUri: baseUri,
                path: 'path',
                method: 'DELETE',
                headers: {
                  'key': 'value',
                },
              );
              expect(request.method, 'DELETE');
              expect(request.url.toString(), 'https://example.com/path');
              expect(request.headers['key'], 'value');
            },
          );
        },
      );
    },
  );
}
