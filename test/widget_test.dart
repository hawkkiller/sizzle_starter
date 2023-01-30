import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sizzle_starter/src/core/utils/mixin/scope_mixin.dart';
import 'package:sizzle_starter/src/core/widget/scope_widgets.dart';

void main() {
  group('ScopeProvider test >', () {
    testWidgets(
      'ScopesProvider must provide all scopes',
      (tester) async {
        await tester.pumpWidget(
          ScopesProvider(
            providers: [
              ScopeProvider(
                buildScope: (child) => _DummyInheritedWidget(child: child),
              ),
              ScopeProvider(
                buildScope: (child) => _DummyInheritedWidget2(child: child),
              ),
            ],
            child: const Placeholder(),
          ),
        );
        final dummy = tester.widget(find.byType(_DummyInheritedWidget));
        final dummy2 = tester.widget(find.byType(_DummyInheritedWidget2));
        expect(
          dummy,
          isA<_DummyInheritedWidget>(),
          reason: '_DummyInheritedWidget must be provided',
        );
        expect(
          dummy2,
          isA<_DummyInheritedWidget2>(),
          reason: '_DummyInheritedWidget2 must be provided',
        );
      },
    );
    testWidgets(
      'ScopeProvider must provide scope',
      (tester) async {
        await tester.pumpWidget(
          ScopeProvider(
            buildScope: (child) => _DummyInheritedWidget(child: child),
            child: const Placeholder(),
          ),
        );
        final dummy = tester.widget(find.byType(_DummyInheritedWidget));
        expect(
          dummy,
          isA<_DummyInheritedWidget>(),
          reason: '_DummyInheritedWidget must be provided',
        );
      },
    );
    testWidgets(
      'ScopeProvider without child must fail',
      (tester) async {
        await tester.pumpWidget(
          ScopeProvider(
            buildScope: (child) => _DummyInheritedWidget(child: child),
          ),
        );
        expect(tester.takeException(), isArgumentError);
      },
    );
  });
}

class _DummyInheritedWidget extends InheritedWidget with ScopeMixin {
  const _DummyInheritedWidget({
    required super.child,
  });

  @override
  bool updateShouldNotify(_DummyInheritedWidget oldWidget) => false;
}

// dummy inherited widget 2

class _DummyInheritedWidget2 extends InheritedWidget with ScopeMixin {
  const _DummyInheritedWidget2({
    required super.child,
  });

  @override
  bool updateShouldNotify(_DummyInheritedWidget2 oldWidget) => false;
}
