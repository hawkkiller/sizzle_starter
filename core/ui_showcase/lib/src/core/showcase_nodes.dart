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
        print('child.fullPath: ${child.fullPath} path: $path');
        if (child.fullPath == path) {
          found = child;
        }
      });

      if (found != null) return found;
    }

    return null;
  }
}
