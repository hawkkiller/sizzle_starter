import 'package:flutter/material.dart';

abstract class ShowcaseNode {
  // Private fields
  ShowcaseNode? _parent;
  int _depth = 0;

  // Abstract getters (must be implemented by subclasses)
  String get name;

  // Virtual getters (can be overridden by subclasses)
  String? get description => null;
  List<String> get tags => const [];
  String? get category => null;
  bool get isDeprecated => false;
  Widget? get widget => null;

  // Computed getters
  /// Get all children (empty for leaf nodes)
  List<ShowcaseNode> get children => const [];

  /// Get parent node
  ShowcaseNode? get parent => _parent;

  /// Get depth in the tree
  int get depth => _depth;

  /// Check if this node is a leaf (has no children)
  bool get isLeaf => children.isEmpty;

  /// Full path from root to this node
  String get path {
    if (_parent == null) return _encodeNameToPath(name);
    return '${_parent!.path}/${_encodeNameToPath(name)}';
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

  void dropChild(ShowcaseNode child) {
    child._parent = null;
  }

  void redepthChild(ShowcaseNode child) {
    if (child._depth <= _depth) {
      child._depth = _depth + 1;
      child.redepthChildren();
    }
  }

  @protected
  void redepthChildren() {}

  void visitChildren(void Function(ShowcaseNode child) visitor) {
    children.forEach(visitor);
  }

  // Navigation and search methods
  /// Find a node by path
  ShowcaseNode? findByPath(String path) {
    if (this.path == path) return this;

    ShowcaseNode? result;
    visitChildren((child) {
      result ??= child.findByPath(path);
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

class ShowcaseFolderNode extends ShowcaseNode {
  ShowcaseFolderNode({
    required this.name,
    required this.children,
    this.description,
    this.tags = const [],
    this.category,
    this.isDeprecated = false,
  }) {
    children.forEach(adoptChild);
  }

  // Override properties
  @override
  final String name;

  @override
  final String? description;

  @override
  final String? category;

  @override
  final List<String> tags;

  @override
  final bool isDeprecated;

  @override
  final List<ShowcaseNode> children;

  // Override methods
  @override
  void redepthChildren() {
    for (final child in children) {
      redepthChild(child);
    }
  }

  @override
  void visitChildren(void Function(ShowcaseNode child) visitor) {
    children.forEach(visitor);
  }
}

class ShowcasePreviewNode extends ShowcaseNode {
  ShowcasePreviewNode({
    required this.name,
    required this.widget,
    this.description,
    this.tags = const [],
    this.category,
    this.isDeprecated = false,
  });

  // Override properties
  @override
  final String name;

  @override
  final String? description;

  @override
  final String? category;

  @override
  final List<String> tags;

  @override
  final bool isDeprecated;

  @override
  final Widget widget;
}
