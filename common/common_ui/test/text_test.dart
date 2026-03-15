import 'package:common_ui/common_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('styles tappable text as a link and invokes the callback', (tester) async {
    var tapped = false;

    await tester.pumpWidget(
      _TestApp(
        child: UiText.bodyMedium(
          'Open details',
          onTap: () => tapped = true,
        ),
      ),
    );

    final text = tester.widget<Text>(find.byType(Text));
    final span = text.textSpan! as TextSpan;
    final style = span.style!;

    expect(style.decoration, TextDecoration.underline);
    expect(style.color, SandgoldTheme().color.primary);

    await tester.tap(find.text('Open details'));
    await tester.pump();

    expect(tapped, isTrue);
  });

  testWidgets('updates the tap recognizer when the callback changes', (tester) async {
    var firstTapCount = 0;
    var secondTapCount = 0;

    await tester.pumpWidget(
      _TestApp(
        child: UiText.bodyMedium(
          'Open details',
          onTap: () => firstTapCount++,
        ),
      ),
    );

    await tester.tap(find.text('Open details'));
    await tester.pump();

    expect(firstTapCount, 1);
    expect(secondTapCount, 0);

    await tester.pumpWidget(
      _TestApp(
        child: UiText.bodyMedium(
          'Open details',
          onTap: () => secondTapCount++,
        ),
      ),
    );

    await tester.tap(find.text('Open details'));
    await tester.pump();

    expect(firstTapCount, 1);
    expect(secondTapCount, 1);
  });
}

class _TestApp extends StatelessWidget {
  const _TestApp({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(body: Center(child: child)),
    );
  }
}
