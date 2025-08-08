import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:ui_showcase/ui_showcase.dart';

RouteBase createRootShowcaseRoute(List<ShowcaseNode> nodes) {
  ShowcaseNodes(nodes).assignParents();

  return ShellRoute(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const SizedBox.shrink(),
        routes: _createRoutes(nodes),
      ),
    ],
    builder: (context, state, child) => GoRouterNotifier(
      nodes: nodes,
      child: ShowcaseView(nodes: nodes, navigator: child),
    ),
  );
}

List<RouteBase> _createRoutes(List<ShowcaseNode> nodes) {
  final routes = <RouteBase>[];

  for (final node in nodes) {
    final childrenRoutes = node.children.isEmpty ? <RouteBase>[] : _createRoutes(node.children);

    routes.add(
      GoRoute(
        path: node.path,
        pageBuilder: (context, state) {
          return NoTransitionPage(child: node.widget ?? const SizedBox.shrink());
        },
        routes: childrenRoutes,
      ),
    );
  }

  return routes;
}

class NodeRouterGoRouter extends ValueNotifier<ShowcaseNode?> implements NodeRouter {
  NodeRouterGoRouter(this._router, this._nodes) : super(null) {
    _router.routerDelegate.addListener(_onLocationChanged);
  }

  final GoRouter _router;
  final List<ShowcaseNode> _nodes;

  @override
  ShowcaseNode? get activeNode => value;

  void _onLocationChanged() {
    final path = _router.state.fullPath ?? '';
    final node = ShowcaseNodes(_nodes).findNodeByPath(path);

    value = node;
  }

  @override
  void updateActiveNode(ShowcaseNode? node) {
    _router.go('/${node?.fullPath ?? ''}');
  }
}

class GoRouterNotifier extends StatefulWidget {
  const GoRouterNotifier({
    required this.nodes,
    required this.child,
    super.key,
  });

  final List<ShowcaseNode> nodes;
  final Widget child;

  @override
  State<GoRouterNotifier> createState() => _GoRouterNotifierState();
}

class _GoRouterNotifierState extends State<GoRouterNotifier> {
  late final NodeRouterGoRouter _nodeRouter;
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _router = GoRouter.of(context);
    _nodeRouter = NodeRouterGoRouter(_router, widget.nodes);
  }

  @override
  Widget build(BuildContext context) {
    return ActiveNodeNotifier(nodeRouter: _nodeRouter, child: widget.child);
  }
}
