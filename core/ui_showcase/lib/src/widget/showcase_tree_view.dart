import 'package:flutter/material.dart';
import 'package:two_dimensional_scrollables/two_dimensional_scrollables.dart';
import 'package:ui_showcase/ui_showcase.dart';

class ShowcaseTreeView extends StatefulWidget {
  const ShowcaseTreeView({
    required this.nodes,
    this.selectedNode,
    this.onNodeSelected,
    super.key,
  });

  final List<ShowcaseNode> nodes;
  final ShowcaseNode? selectedNode;
  final ValueChanged<ShowcaseNode>? onNodeSelected;

  static Widget _nodeBuilder({
    required BuildContext context,
    required TreeViewNode<ShowcaseNode> node,
    required AnimationStyle animationStyle,
    required ValueChanged<TreeViewNode<ShowcaseNode>> onNodeSelected,
  }) {
    final animationDuration = animationStyle.duration ?? TreeView.defaultAnimationDuration;
    final animationCurve = animationStyle.curve ?? TreeView.defaultAnimationCurve;

    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: GestureDetector(
        onTap: () => onNodeSelected(node),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: 4,
          children: [
            if (node.children.isNotEmpty)
              AnimatedSwitcher(
                duration: animationDuration,
                switchInCurve: animationCurve,
                switchOutCurve: animationCurve,
                child: Icon(
                  node.isExpanded ? Icons.folder_open : Icons.folder,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  key: ValueKey<bool>(node.isExpanded),
                ),
              ),
            Text(node.content.name),
          ],
        ),
      ),
    );
  }

  @override
  State<ShowcaseTreeView> createState() => _ShowcaseTreeViewState();
}

class _ShowcaseTreeViewState extends State<ShowcaseTreeView> {
  late final _nodes = _buildTree(widget.nodes);

  List<TreeViewNode<ShowcaseNode>> _buildTree(List<ShowcaseNode> nodes) {
    return nodes
        .map((node) => TreeViewNode(node, children: _buildTree(node.children)))
        .toList(growable: false);
  }

  void _onNodeSelected(BuildContext context, TreeViewNode<ShowcaseNode> node) {
    if (node.children.isNotEmpty) {
      TreeViewController.of(context).toggleNode(node);
      return;
    }

    widget.onNodeSelected?.call(node.content);
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainer,
        border: Border(
          right: BorderSide(
            color: Theme.of(context).colorScheme.outlineVariant,
          ),
        ),
      ),
      child: TreeView<ShowcaseNode>(
        tree: _nodes,
        treeRowBuilder: (node) => const TreeRow(extent: FixedTreeRowExtent(32)),
        treeNodeBuilder: (context, node, style) => ShowcaseTreeView._nodeBuilder(
          context: context,
          node: node,
          animationStyle: style,
          onNodeSelected: (node) => _onNodeSelected(context, node),
        ),
        toggleAnimationStyle: const AnimationStyle(
          duration: Duration(milliseconds: 100),
          curve: Curves.easeInOut,
          reverseCurve: Curves.easeInOut,
        ),
      ),
    );
  }
}
