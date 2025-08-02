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
    required bool isSelected,
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
            Text(
              node.content.name,
              style: TextStyle(color: isSelected ? Theme.of(context).colorScheme.primary : null),
            ),
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
  final _treeViewController = TreeViewController();

  List<TreeViewNode<ShowcaseNode>> _buildTree(List<ShowcaseNode> nodes) {
    final treeViewNodes = <TreeViewNode<ShowcaseNode>>[];

    for (final node in nodes) {
      var isExpanded = false;

      if (widget.selectedNode case final selectedNode?) {
        isExpanded = selectedNode.findByName(selectedNode.name) != null;
      }

      final treeViewNode = TreeViewNode(
        node,
        children: _buildTree(node.children),
        expanded: isExpanded,
      );

      treeViewNodes.add(treeViewNode);
    }

    return treeViewNodes;
  }

  void _onNodeSelected(TreeViewNode<ShowcaseNode> node) {
    if (node.children.isNotEmpty) {
      _treeViewController.toggleNode(node);
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
        controller: _treeViewController,
        treeRowBuilder: (node) => const TreeRow(extent: FixedTreeRowExtent(32)),
        treeNodeBuilder: (context, node, style) => ShowcaseTreeView._nodeBuilder(
          context: context,
          node: node,
          animationStyle: style,
          onNodeSelected: _onNodeSelected,
          isSelected: node.content == widget.selectedNode,
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
