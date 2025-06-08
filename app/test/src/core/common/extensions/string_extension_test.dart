import 'package:flutter_test/flutter_test.dart';
import 'package:sizzle_starter/src/core/common/extensions/string_extension.dart';

void main() {
  group('StringExtension.limit', () {
    const sample = 'Hello';

    test('returns original string when length is negative', () {
      expect(sample.limit(-1), sample);
    });

    test('returns empty string when length is zero', () {
      expect(sample.limit(0), '');
    });

    test('returns substring when length is less than string length', () {
      expect(sample.limit(2), 'He');
    });

    test('returns original string when length exceeds length', () {
      expect(sample.limit(10), sample);
    });
  });
}
