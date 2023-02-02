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
    },
  );
}
