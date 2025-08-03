import 'package:flutter/material.dart';

class ShowcaseNode {
  ShowcaseNode({
    required this.name,
    this.description,
    this.tags = const [],
    this.category,
    this.isDeprecated = false,
    this.widget,
    this.children = const [],
  });

  // Private fields
  ShowcaseNode? _parent;
  int _depth = 0;

  // Public properties
  final String name;
  final String? description;
  final List<String> tags;
  final String? category;
  final bool isDeprecated;
  final Widget? widget;
  final List<ShowcaseNode> children;

  // Computed getters
  /// Get parent node
  ShowcaseNode? get parent => _parent;

  /// Get depth in the tree
  int get depth => _depth;

  /// Check if this node is a leaf (has no children)
  bool get isLeaf => children.isEmpty;

  /// Full path from root to this node
  String get fullPath {
    if (_parent == null) return _encodeNameToPath(name);
    return '${_parent!.fullPath}/${_encodeNameToPath(name)}';
  }

  String get path {
    return _encodeNameToPath(name);
  }

  String _encodeNameToPath(String name) {
    return name.toLowerCase().replaceAll(' ', '-');
  }

  // Tree manipulation methods
  void adoptChild(ShowcaseNode child) {
    assert(child._parent == null, 'Node already has a parent');
    child._parent = this;
    redepthChild(child);
  }

  void redepthChild(ShowcaseNode child) {
    if (child._depth <= _depth) {
      child._depth = _depth + 1;
      child.redepthChildren();
    }
  }

  void redepthChildren() {
    for (final child in children) {
      redepthChild(child);
    }
  }

  void visitChildren(void Function(ShowcaseNode child) visitor) {
    children.forEach(visitor);

    for (final child in children) {
      child.visitChildren(visitor);
    }
  }

  // Navigation and search methods
  /// Find a node by path
  ShowcaseNode? findByPath(String path) {
    if (fullPath == path) return this;

    ShowcaseNode? result;
    visitChildren((child) {
      result ??= child.findByPath(path);
    });
    return result;
  }

  ShowcaseNode? findByName(String name) {
    if (this.name == name) return this;

    ShowcaseNode? result;
    visitChildren((child) {
      result ??= child.findByName(name);
    });
    return result;
  }

  /// Get breadcrumb path to this node
  List<ShowcaseNode> getBreadcrumbs() {
    final breadcrumbs = <ShowcaseNode>[];
    ShowcaseNode? current = this;

    while (current != null) {
      breadcrumbs.insert(0, current);
      current = current.parent;
    }

    return breadcrumbs;
  }
}

mixin ShowcaseNodeMixin on Widget implements ShowcaseNode {
  
}
