import 'package:common_ui/common_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows and dismisses a snackbar', (tester) async {
    await tester.pumpWidget(const _TestApp());

    await tester.tap(find.text('Show snackbar'));
    await tester.pump();

    expect(find.text('Saved successfully'), findsOneWidget);

    final uiCard = tester.widget<UiCard>(
      find.ancestor(
        of: find.text('Saved successfully'),
        matching: find.byType(UiCard),
      ),
    );

    expect(uiCard.color, SandgoldTheme().color.surfaceInverse);

    await tester.pump(const Duration(milliseconds: 450));

    expect(find.text('Saved successfully'), findsNothing);
  });

  testWidgets('shows queued snackbars one at a time', (tester) async {
    await tester.pumpWidget(const _TestApp());

    await tester.tap(find.text('Queue snackbars'));
    await tester.pump();

    expect(find.text('First message'), findsOneWidget);
    expect(find.text('Second message'), findsNothing);

    await tester.pump(const Duration(milliseconds: 650));

    expect(find.text('First message'), findsNothing);
    expect(find.text('Second message'), findsOneWidget);
  });

  testWidgets('invokes the snackbar action callback', (tester) async {
    var actionPressed = false;

    await tester.pumpWidget(
      _TestApp(onActionPressed: () => actionPressed = true),
    );

    await tester.tap(find.text('Show action snackbar'));
    await tester.pump();

    expect(find.text('Project archived'), findsOneWidget);

    await tester.tap(find.text('Undo'));
    await tester.pump();

    expect(actionPressed, isTrue);
  });

  testWidgets('uses inverse accent color for neutral snackbar actions', (tester) async {
    final theme = SandgoldTheme();

    await tester.pumpWidget(const _TestApp());

    await tester.tap(find.text('Show action snackbar'));
    await tester.pump();

    final button = tester.widget<FilledButton>(
      find.descendant(
        of: find.byType(UiSnackbar),
        matching: find.byType(FilledButton),
      ),
    );

    expect(
      button.style?.foregroundColor?.resolve(<WidgetState>{}),
      theme.color.primaryInverse,
    );
  });

  testWidgets('keeps single-line snackbars compact with and without actions', (tester) async {
    await tester.pumpWidget(const _TestApp());

    await tester.tap(find.text('Show snackbar'));
    await tester.pump();

    final withoutActionHeight = tester.getSize(find.byType(UiSnackbar)).height;

    await tester.pumpWidget(const _TestApp());
    await tester.tap(find.text('Show action snackbar'));
    await tester.pump();

    final withActionHeight = tester.getSize(find.byType(UiSnackbar)).height;

    expect(withoutActionHeight, 52);
    expect(withActionHeight, 52);
  });

  testWidgets('applies the snackbar variant colors', (tester) async {
    await tester.pumpWidget(const _TestApp());

    await tester.tap(find.text('Show error snackbar'));
    await tester.pump();

    final uiCard = tester.widget<UiCard>(
      find.ancestor(
        of: find.text('Could not save changes'),
        matching: find.byType(UiCard),
      ),
    );

    expect(uiCard.color, SandgoldTheme().color.error);
  });

  testWidgets('moves the snackbar above the keyboard inset', (tester) async {
    await tester.pumpWidget(const _TestApp());

    await tester.tap(find.text('Show snackbar'));
    await tester.pump();

    final withoutKeyboardBottom = tester.getBottomLeft(find.byType(UiSnackbar)).dy;

    await tester.pumpWidget(const _TestApp(bottomInset: 200));
    await tester.tap(find.text('Show snackbar'));
    await tester.pump();

    final withKeyboardBottom = tester.getBottomLeft(find.byType(UiSnackbar)).dy;

    expect(withKeyboardBottom, lessThan(withoutKeyboardBottom - 150));
  });
}

class _TestApp extends StatelessWidget {
  const _TestApp({this.bottomInset = 0, this.onActionPressed});

  final double bottomInset;
  final VoidCallback? onActionPressed;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: SandgoldTheme().buildThemeData(),
      builder: (context, child) {
        final mediaQuery = MediaQuery.of(context);

        return MediaQuery(
          data: mediaQuery.copyWith(viewInsets: EdgeInsets.only(bottom: bottomInset)),
          child: UiSnackbarHost(child: child!),
        );
      },
      home: Scaffold(
        body: _TestHarness(onActionPressed: onActionPressed),
      ),
    );
  }
}

class _TestHarness extends StatelessWidget {
  const _TestHarness({this.onActionPressed});

  final VoidCallback? onActionPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        UiButton(
          label: 'Show snackbar',
          onPressed: () {
            showUiSnackbar(
              context,
              message: 'Saved successfully',
              duration: const Duration(milliseconds: 300),
            );
          },
        ),
        UiButton(
          label: 'Queue snackbars',
          onPressed: () {
            final controller = UiSnackbarScope.of(context, listen: false).controller;

            controller.show(
              const UiSnackbarData(
                message: 'First message',
                duration: Duration(milliseconds: 500),
              ),
            );
            controller.show(
              const UiSnackbarData(
                message: 'Second message',
                duration: Duration(milliseconds: 500),
              ),
            );
          },
        ),
        UiButton(
          label: 'Show error snackbar',
          onPressed: () {
            showUiSnackbar(
              context,
              message: 'Could not save changes',
              variant: UiSnackbarVariant.error,
              duration: const Duration(seconds: 5),
            );
          },
        ),
        UiButton(
          label: 'Show action snackbar',
          onPressed: () {
            showUiSnackbar(
              context,
              message: 'Project archived',
              duration: const Duration(seconds: 5),
              action: UiSnackbarAction(
                label: 'Undo',
                onPressed: onActionPressed ?? () {},
              ),
            );
          },
        ),
      ],
    );
  }
}
