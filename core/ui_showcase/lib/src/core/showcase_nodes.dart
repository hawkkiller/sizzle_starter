import 'package:ui_showcase/ui_showcase.dart';

extension type ShowcaseNodes(List<ShowcaseNode> nodes) {
  ShowcaseNode? findNodeByName(String name) {
    for (final node in nodes) {
      if (node.name == name) return node;
      ShowcaseNode? found;

      node.visitChildren((child) {
        if (child.name == name) {
          found = child;
        }
      });

      if (found != null) return found;
    }

    return null;
  }

  ShowcaseNode? findNodeByPath(String path) {
    for (final node in nodes) {
      if (node.fullPath == path) return node;
      ShowcaseNode? found;

      node.visitChildren((child) {
        if (child.fullPath == path) {
          found = child;
        }
      });

      if (found != null) return found;
    }

    return null;
  }

  void assignParents({
    int depth = 0,
    List<ShowcaseNode>? nodes,
    ShowcaseNode? parent,
  }) {
    nodes ??= this.nodes;

    for (final node in nodes) {
      parent?.adoptChild(node);

      if (node.children.isNotEmpty) {
        assignParents(
          depth: depth + 1,
          nodes: node.children,
          parent: node,
        );
      }
    }
  }
}
