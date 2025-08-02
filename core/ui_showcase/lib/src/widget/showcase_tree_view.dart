import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:two_dimensional_scrollables/two_dimensional_scrollables.dart';
import 'package:ui_showcase/ui_showcase.dart';

/// A tree view widget for displaying showcase nodes in a hierarchical structure.
///
/// This widget provides an intuitive interface for navigating through UI components
/// with features like expandable folders, selection highlighting, and smooth animations.
class ShowcaseTreeView extends StatefulWidget {
  const ShowcaseTreeView({
    required this.nodes,
    this.selectedNode,
    this.onNodeSelected,
    super.key,
  });

  /// The root nodes to display in the tree
  final List<ShowcaseNode> nodes;

  /// The currently selected node, if any
  final ShowcaseNode? selectedNode;

  /// Callback fired when a node is selected
  final ValueChanged<ShowcaseNode>? onNodeSelected;

  static const double _nodeHeight = 36.0;
  static const double _nodeIndentation = 8.0;
  static const double _iconSize = 18.0;
  static const Duration _animationDuration = Duration(milliseconds: 150);
  static const Curve _animationCurve = Curves.easeInOutCubic;

  @override
  State<ShowcaseTreeView> createState() => _ShowcaseTreeViewState();
}

class _ShowcaseTreeViewState extends State<ShowcaseTreeView> {
  late final List<TreeViewNode<ShowcaseNode>> _treeNodes;
  final TreeViewController _treeViewController = TreeViewController();

  @override
  void initState() {
    super.initState();
    _treeNodes = _buildTreeNodes(widget.nodes);
  }

  List<TreeViewNode<ShowcaseNode>> _buildTreeNodes(List<ShowcaseNode> nodes) {
    return nodes.map(_createTreeViewNode).toList();
  }

  TreeViewNode<ShowcaseNode> _createTreeViewNode(ShowcaseNode node) {
    final isExpanded = _shouldNodeBeExpanded(node);

    return TreeViewNode(
      node,
      children: _buildTreeNodes(node.children),
      expanded: isExpanded,
    );
  }

  bool _shouldNodeBeExpanded(ShowcaseNode node) {
    final selectedNode = widget.selectedNode;
    if (selectedNode == null) return false;

    return node.findByName(selectedNode.name) != null;
  }

  void _handleNodeSelection(TreeViewNode<ShowcaseNode> treeNode) {
    HapticFeedback.selectionClick();

    if (treeNode.children.isNotEmpty) {
      _treeViewController.toggleNode(treeNode);
    } else {
      widget.onNodeSelected?.call(treeNode.content);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainer,
        border: Border(
          right: BorderSide(color: theme.colorScheme.outlineVariant),
        ),
      ),
      child: TreeView<ShowcaseNode>(
        tree: _treeNodes,
        controller: _treeViewController,
        indentation: TreeViewIndentationType.none,
        treeRowBuilder: (_) => const TreeRow(
          extent: FixedTreeRowExtent(ShowcaseTreeView._nodeHeight),
        ),
        treeNodeBuilder: (context, node, animationStyle) => _TreeNodeWidget(
          node: node,
          animationStyle: animationStyle,
          onNodeSelected: _handleNodeSelection,
          isSelected: node.content == widget.selectedNode,
        ),
        toggleAnimationStyle: const AnimationStyle(
          duration: ShowcaseTreeView._animationDuration,
          curve: ShowcaseTreeView._animationCurve,
          reverseCurve: ShowcaseTreeView._animationCurve,
        ),
      ),
    );
  }
}

class _TreeNodeWidget extends StatefulWidget {
  const _TreeNodeWidget({
    required this.node,
    required this.animationStyle,
    required this.onNodeSelected,
    required this.isSelected,
  });

  final TreeViewNode<ShowcaseNode> node;
  final AnimationStyle animationStyle;
  final ValueChanged<TreeViewNode<ShowcaseNode>> onNodeSelected;
  final bool isSelected;

  @override
  State<_TreeNodeWidget> createState() => _TreeNodeWidgetState();
}

class _TreeNodeWidgetState extends State<_TreeNodeWidget> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final node = widget.node;
    final showcaseNode = node.content;
    final hasChildren = node.children.isNotEmpty;

    final backgroundColor = _getBackgroundColor(theme);
    final textColor = _getTextColor(theme);
    final iconColor = _getIconColor(theme);

    return MouseRegion(
      onEnter: (_) => _setHovered(true),
      onExit: (_) => _setHovered(false),
      child: GestureDetector(
        onTap: () => widget.onNodeSelected(node),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minWidth: 200),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(6),
                border: widget.isSelected
                    ? Border.all(color: theme.colorScheme.primary.withValues(alpha: 0.3))
                    : null,
              ),
              child: Padding(
                padding: EdgeInsets.only(
                  left: ShowcaseTreeView._nodeIndentation * (showcaseNode.depth + 1),
                  top: 6,
                  bottom: 6,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (hasChildren) ...[
                      _buildExpansionIcon(iconColor),
                      const SizedBox(width: 8),
                    ] else ...[
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: SizedBox(
                          width: ShowcaseTreeView._iconSize,
                          height: ShowcaseTreeView._iconSize,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: iconColor.withValues(alpha: 0.2),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.album_rounded,
                              size: 12,
                              color: iconColor,
                            ),
                          ),
                        ),
                      ),
                    ],

                    Flexible(
                      child: Text(
                        showcaseNode.name,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: textColor,
                          height: 1.2,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildExpansionIcon(Color iconColor) {
    final animationDuration = widget.animationStyle.duration ?? ShowcaseTreeView._animationDuration;
    final animationCurve = widget.animationStyle.curve ?? ShowcaseTreeView._animationCurve;

    return AnimatedSwitcher(
      duration: animationDuration,
      switchInCurve: animationCurve,
      switchOutCurve: animationCurve,
      child: Icon(
        widget.node.isExpanded ? Icons.folder_open_outlined : Icons.folder_outlined,
        color: iconColor,
        size: ShowcaseTreeView._iconSize,
        key: ValueKey<bool>(widget.node.isExpanded),
      ),
    );
  }

  Color _getBackgroundColor(ThemeData theme) {
    if (widget.isSelected) {
      return theme.colorScheme.primaryContainer.withValues(alpha: 0.3);
    }

    if (_isHovered) {
      return theme.colorScheme.onSurface.withValues(alpha: 0.05);
    }

    return Colors.transparent;
  }

  Color _getTextColor(ThemeData theme) {
    if (widget.isSelected) {
      return theme.colorScheme.onPrimaryContainer;
    }

    if (widget.node.content.isDeprecated) {
      return theme.colorScheme.onSurface.withValues(alpha: 0.6);
    }

    return theme.colorScheme.onSurface;
  }

  Color _getIconColor(ThemeData theme) {
    if (widget.isSelected) {
      return theme.colorScheme.primary;
    }
    if (_isHovered) {
      return theme.colorScheme.onSurface.withValues(alpha: 0.8);
    }
    return theme.colorScheme.onSurfaceVariant;
  }

  void _setHovered(bool hovered) {
    if (_isHovered != hovered) {
      setState(() {
        _isHovered = hovered;
      });
    }
  }
}
