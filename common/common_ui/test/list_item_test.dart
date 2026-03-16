import 'package:common_ui/common_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renders title, subtitle, leading, and trailing content', (tester) async {
    await tester.pumpWidget(
      _TestApp(
        child: UiListItem(
          title: 'Notifications',
          subtitle: 'Push, email, and product updates',
          leading: const Icon(Icons.notifications_outlined),
          trailing: const Text('Enabled'),
          onPressed: () {},
        ),
      ),
    );

    expect(find.text('Notifications'), findsOneWidget);
    expect(find.text('Push, email, and product updates'), findsOneWidget);
    expect(find.byIcon(Icons.notifications_outlined), findsOneWidget);
    expect(find.text('Enabled'), findsOneWidget);
  });

  testWidgets('invokes onPressed when tapped', (tester) async {
    var tapCount = 0;

    await tester.pumpWidget(
      _TestApp(
        child: UiListItem(
          title: 'Account',
          onPressed: () => tapCount++,
        ),
      ),
    );

    await tester.tap(find.text('Account'));
    await tester.pump();

    expect(tapCount, 1);
  });

  testWidgets('does not invoke onPressed when disabled', (tester) async {
    var tapCount = 0;

    await tester.pumpWidget(
      _TestApp(
        child: UiListItem(
          title: 'Security',
          enabled: false,
          onPressed: () => tapCount++,
        ),
      ),
    );

    await tester.tap(find.text('Security'));
    await tester.pump();

    expect(tapCount, 0);
  });

  testWidgets('uses primary container colors for selected items', (tester) async {
    final theme = SandgoldTheme();

    await tester.pumpWidget(
      const _TestApp(
        child: UiListItem(
          title: 'Selected item',
          subtitle: 'Current selection',
          selected: true,
        ),
      ),
    );

    final surface = tester.widget<DecoratedBox>(_surfaceFinder('Selected item'));
    final decoration = surface.decoration as ShapeDecoration;
    final title = tester.widget<Text>(find.text('Selected item'));

    expect(decoration.color, theme.color.primaryContainer);
    expect(title.style?.color, theme.color.onPrimaryContainer);
  });
}

Finder _surfaceFinder(String title) {
  return find
      .descendant(
        of: find.ancestor(
          of: find.text(title),
          matching: find.byType(UiListItem),
        ),
        matching: find.byType(DecoratedBox),
      )
      .last;
}

class _TestApp extends StatelessWidget {
  const _TestApp({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: SandgoldTheme().buildThemeData(),
      home: Scaffold(
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 360),
            child: child,
          ),
        ),
      ),
    );
  }
}
