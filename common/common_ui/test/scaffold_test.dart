import 'package:common_ui/common_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('hosts snackbars for the current screen', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: SandgoldTheme().buildThemeData(),
        home: UiScaffold(
          body: Builder(
            builder: (context) => Center(
              child: UiButton(
                label: 'Show snackbar',
                onPressed: () {
                  showUiSnackbar(
                    context,
                    message: 'Saved successfully',
                    duration: const Duration(seconds: 5),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Show snackbar'));
    await tester.pump();

    expect(find.text('Saved successfully'), findsOneWidget);
  });
}
