import 'package:blaze_starter/src/core/utils/mixin/scope_mixin.dart';
import 'package:flutter/material.dart';

typedef BuildScope = ScopeMixin Function(Widget child);

class ScopesProvider extends StatefulWidget {
  const ScopesProvider({
    required this.child,
    required this.buildScopes,
    super.key,
  });

  final Widget child;

  final List<BuildScope> buildScopes;

  @override
  State<ScopesProvider> createState() => _ScopesProviderState();
}

class _ScopesProviderState extends State<ScopesProvider> {
  Widget? _topmostScope;
  late final List<BuildScope> _buildScopes;

  @override
  void didUpdateWidget(ScopesProvider oldWidget) {
    if (oldWidget.child != widget.child) {
      _computeTopmostScope();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    _buildScopes = widget.buildScopes.reversed.toList();
    _computeTopmostScope();
    super.initState();
  }

  void _computeTopmostScope() {
    _topmostScope ??= _buildScopes.fold(
      widget.child,
      (previousValue, element) => element(previousValue!),
    );
  }

  @override
  Widget build(BuildContext context) => _topmostScope ??= widget.child;
}
