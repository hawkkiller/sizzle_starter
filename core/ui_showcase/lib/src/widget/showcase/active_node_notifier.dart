import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ui_showcase/ui_showcase.dart';

class ActiveNodeProvider extends StatefulWidget {
  const ActiveNodeProvider({
    required this.nodes,
    required this.child,
    super.key,
  });

  final List<ShowcaseNode> nodes;
  final Widget child;

  static ActiveNodeProviderState of(BuildContext context, {bool listen = true}) {
    final widget = listen
        ? context.dependOnInheritedWidgetOfExactType<_InheritedNodeNotifier>()
        : context.getInheritedWidgetOfExactType<_InheritedNodeNotifier>();

    if (widget == null) {
      throw FlutterError('No ActiveNodeProvider found in context');
    }

    return widget.state;
  }

  @override
  State<ActiveNodeProvider> createState() => ActiveNodeProviderState();
}

class ActiveNodeProviderState extends State<ActiveNodeProvider> {
  late final ActiveNodeNotifier _notifier;
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _router = GoRouter.of(context);
    _notifier = ActiveNodeNotifier(router: _router, nodes: widget.nodes);
  }

  ShowcaseNode? get activeNode => _notifier.value;

  void updateActiveNode(ShowcaseNode? node) {
    _router.go('/${node?.fullPath ?? ''}');
  }

  @override
  Widget build(BuildContext context) {
    return _InheritedNodeNotifier(
      state: this,
      notifier: _notifier,
      child: widget.child,
    );
  }
}

class ActiveNodeNotifier extends ValueNotifier<ShowcaseNode?> {
  ActiveNodeNotifier({
    required this.router,
    required this.nodes,
  }) : super(_nodeFromPath(router.state.fullPath ?? '', nodes)) {
    router.routerDelegate.addListener(_onRouteChange);
  }

  final GoRouter router;
  final List<ShowcaseNode> nodes;

  static ShowcaseNode? _nodeFromPath(String path, List<ShowcaseNode> nodes) {
    return ShowcaseNodes(nodes).findNodeByPath(path.replaceFirst('/', ''));
  }

  void _onRouteChange() {
    value = _nodeFromPath(router.state.fullPath ?? '', nodes);
  }

  @override
  void dispose() {
    router.routerDelegate.removeListener(_onRouteChange);
    super.dispose();
  }
}

class _InheritedNodeNotifier extends InheritedNotifier {
  const _InheritedNodeNotifier({
    required super.notifier,
    required super.child,
    required this.state,
  });

  final ActiveNodeProviderState state;
}
