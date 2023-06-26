import 'package:flutter/material.dart';
import 'package:sizzle_starter/src/core/router/router.dart';
import 'package:sizzle_starter/src/core/utils/mixin/scope_mixin.dart';

/// A widget which is responsible for providing the [AppRouter].
class AppRouterScope extends StatefulWidget with ScopeMixin {
  const AppRouterScope({required this.child, super.key});

  @override
  final Widget child;

  /// Returns the [AppRouter] from the closest [AppRouterScope] ancestor.
  static AppRouter of(
    BuildContext context, {
    bool listen = true,
  }) =>
      ScopeMixin.scopeOf<_AppRouterInherited>(context, listen: listen).router;

  @override
  State<AppRouterScope> createState() => _AppRouterScopeState();
}

class _AppRouterScopeState extends State<AppRouterScope> {
  late final AppRouter _router;

  @override
  void initState() {
    super.initState();
    _router = AppRouter();
  }

  @override
  Widget build(BuildContext context) => _AppRouterInherited(
        router: _router,
        child: widget.child,
      );
}

class _AppRouterInherited extends InheritedWidget {
  const _AppRouterInherited({
    required this.router,
    required super.child,
  });

  final AppRouter router;

  @override
  bool updateShouldNotify(_AppRouterInherited oldWidget) =>
      oldWidget.router != router;
}
