import 'package:common_translations/common_translations.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('exposes supported locales', () {
    expect(
      CommonTranslations.supportedLocales,
      const [Locale('en')],
    );
  });

  test('exposes package localization delegate', () {
    expect(
      CommonTranslations.localizationsDelegates,
      contains(CommonTranslationsLocalizations.delegate),
    );
  });
}
