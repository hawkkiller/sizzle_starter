import 'package:common_ui/common_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('separates base and interactive neutral surface tokens', () {
    final color = SandgoldTheme().color;

    expect(color.surface, isNot(color.surfaceInteractive));
  });

  testWidgets('secondary button uses a different fill from the base surface', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: SandgoldTheme().buildThemeData(),
        home: const Scaffold(
          body: Column(
            children: [
              UiCard(child: SizedBox(width: 20, height: 20)),
              UiButton(
                label: 'Secondary',
                style: UiButtonStyle.secondary,
                onPressed: _noop,
              ),
            ],
          ),
        ),
      ),
    );

    final button = tester.widget<FilledButton>(find.byType(FilledButton));
    final buttonColor = button.style?.backgroundColor?.resolve(<WidgetState>{});
    final card = tester.widget<UiCard>(find.byType(UiCard));

    expect(card.color ?? SandgoldTheme().color.surface, isNot(buttonColor));
  });

  testWidgets('button colors can be overridden without changing the button style', (tester) async {
    final theme = SandgoldTheme();

    await tester.pumpWidget(
      MaterialApp(
        theme: theme.buildThemeData(),
        home: Scaffold(
          body: UiButton(
            label: 'Custom',
            style: UiButtonStyle.ghost,
            colors: UiButtonColors(
              foreground: theme.color.success,
              disabledForeground: theme.color.success.withValues(
                alpha: theme.color.success.a * theme.opacity.disabled,
              ),
              overlay: theme.color.success.withValues(alpha: theme.opacity.hover),
            ),
            onPressed: _noop,
          ),
        ),
      ),
    );

    final button = tester.widget<FilledButton>(find.byType(FilledButton));

    expect(
      button.style?.foregroundColor?.resolve(<WidgetState>{}),
      theme.color.success,
    );
  });
}

void _noop() {}
