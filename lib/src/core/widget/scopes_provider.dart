import 'package:flutter/material.dart';
import 'package:sizzle_starter/src/core/utils/mixin/scope_mixin.dart';

typedef BuildScope = ScopeMixin Function(Widget child);

/// A widget that provides a list of scopes to its descendants.
/// The order of the scope matters.
class ScopesProvider extends StatefulWidget {
  const ScopesProvider({
    required this.child,
    required this.buildScopes,
    super.key,
  });

  /// The widget below this widget in the tree.
  /// Note that if you want to read values from the scopes, check if
  /// you have right [BuildContext] for that.
  final Widget child;

  /// List of scopes to provide to descendants.
  final List<BuildScope> buildScopes;

  @override
  State<ScopesProvider> createState() => _ScopesProviderState();
}

class _ScopesProviderState extends State<ScopesProvider> {
  Widget? _topmostScope;
  List<BuildScope>? _buildScopes;

  @override
  void didUpdateWidget(ScopesProvider oldWidget) {
    if (oldWidget.child != widget.child || oldWidget.buildScopes != widget.buildScopes) {
      _computeTopmostScope();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    _computeTopmostScope();
    super.initState();
  }

  void _computeTopmostScope() {
    _buildScopes = widget.buildScopes.reversed.toList();
    _topmostScope = _buildScopes?.fold(
      widget.child,
      (previousValue, element) => element(previousValue!),
    );
  }

  @override
  Widget build(BuildContext context) => _topmostScope ?? widget.child;
}
