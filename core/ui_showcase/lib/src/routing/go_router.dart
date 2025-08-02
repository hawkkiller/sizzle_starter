import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:ui_showcase/ui_showcase.dart';

GoRouter createRouter(List<ShowcaseNode> nodes) {
  return GoRouter(
    debugLogDiagnostics: true,
    routes: [
      ShellRoute(
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => const SizedBox.shrink(),
            routes: createRoutes(nodes),
          ),
        ],
        builder: (context, state, child) => ShowcaseView(
          nodes: nodes,
          navigator: child,
        ),
      ),
    ],
  );
}

List<RouteBase> createRoutes(List<ShowcaseNode> nodes) {
  final routes = <RouteBase>[];

  for (final node in nodes) {
    final childrenRoutes = node.children.isEmpty ? <RouteBase>[] : createRoutes(node.children);

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
