import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:sizzle_starter/src/core/utils/mixin/scope_mixin.dart';

typedef BuildScope<T extends Widget> = ScopeMixin<T> Function(Widget child);

typedef BuildWidget = Widget Function(BuildContext context, Widget? child);

@alwaysThrows
Never _childIsNull() => throw ArgumentError.notNull('child');

class ScopeProvider<T extends Widget> extends StatelessWidget {
  const ScopeProvider({
    required this.buildScope,
    this.child,
    super.key,
  });

  final BuildScope<T> buildScope;

  final Widget? child;

  @override
  Widget build(BuildContext context) => buildScope(child ?? _childIsNull());
}

/// A widget that provides a list of scopes to its descendants.
/// The order of the scope matters.
class ScopesProvider extends StatelessWidget with ScopeMixin {
  const ScopesProvider({
    required this.child,
    required this.providers,
    super.key,
  });

  /// The widget below this widget in the tree.
  /// Note that if you want to read values from the scopes, check if
  /// you have right [BuildContext] for that.
  @override
  final Widget child;

  /// List of scopes to provide to descendants.
  final List<ScopeProvider> providers;

  @override
  Widget build(BuildContext context) => providers.reversed.fold<Widget>(
        child,
        (previousValue, element) => element.buildScope(previousValue),
      );
}
