import 'package:common_ui/common_ui.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('parent recognizers apply to nested child text', (tester) async {
    var taps = 0;
    final recognizer = TapGestureRecognizer()..onTap = () => taps += 1;
    addTearDown(recognizer.dispose);

    await tester.pumpWidget(
      MaterialApp(
        theme: SandgoldTheme().buildThemeData(),
        home: Scaffold(
          body: Center(
            child: UiText.markup(
              '<link><bold>Tap</bold></link>',
              type: UiTypographySize.bodyMedium,
              builders: {
                'link': (tag) => TextSpan(recognizer: recognizer, children: tag.children),
                'bold': (tag) => TextSpan(
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  children: tag.children,
                ),
              },
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Tap'));
    await tester.pump();

    expect(taps, 1);
  });

  testWidgets('child recognizers override inherited parent recognizers', (tester) async {
    var parentTaps = 0;
    var childTaps = 0;
    final parentRecognizer = TapGestureRecognizer()..onTap = () => parentTaps += 1;
    final childRecognizer = TapGestureRecognizer()..onTap = () => childTaps += 1;

    addTearDown(parentRecognizer.dispose);
    addTearDown(childRecognizer.dispose);

    await tester.pumpWidget(
      MaterialApp(
        theme: SandgoldTheme().buildThemeData(),
        home: Scaffold(
          body: Center(
            child: UiText.markup(
              '<link><bold>Tap</bold></link>',
              type: UiTypographySize.bodyMedium,
              builders: {
                'link': (tag) => TextSpan(recognizer: parentRecognizer, children: tag.children),
                'bold': (tag) => TextSpan(
                  recognizer: childRecognizer,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  children: tag.children,
                ),
              },
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Tap'));
    await tester.pump();

    expect(parentTaps, 0);
    expect(childTaps, 1);
  });
}
