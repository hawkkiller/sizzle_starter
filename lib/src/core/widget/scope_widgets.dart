import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Typedef that defines a scope builder.
typedef BuildScope = Widget Function(Widget child);

/// Typedef that defines a widget builder.
typedef BuildWidget = Widget Function(BuildContext context, Widget? child);

Never _childIsNull() => throw ArgumentError.notNull('child');

/// {@template scope_provider}
/// A widget that provides a scope to its descendants.
/// {@endtemplate}
class ScopeProvider extends StatelessWidget {
  /// {@macro scope_provider}
  const ScopeProvider({
    required this.buildScope,
    this.child,
    super.key,
  });

  /// The widget below this widget in the tree.
  final BuildScope buildScope;

  /// The widget below this widget in the tree.
  final Widget? child;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      ObjectFlagProperty<BuildScope>.has('buildScope', buildScope),
    );
  }

  @override
  Widget build(BuildContext context) => buildScope(child ?? _childIsNull());
}

/// {@template scopes_provider}
/// A widget that provides a list of scopes to its descendants.
/// {@endtemplate}
class ScopesProvider extends StatelessWidget {
  /// {@macro scopes_provider}
  const ScopesProvider({
    required this.child,
    required this.providers,
    super.key,
  });

  /// The widget below this widget in the tree.
  /// Note that if you want to read values from the scopes, check if
  /// you have right [BuildContext] for that.
  final Widget child;

  /// List of scopes to provide to descendants.
  final List<ScopeProvider> providers;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      IterableProperty<ScopeProvider>('providers', providers),
    );
  }

  @override
  Widget build(BuildContext context) => providers.reversed.fold<Widget>(
        child,
        (previousValue, element) => element.buildScope(previousValue),
      );
}
