import 'package:flutter/material.dart';
import 'package:ui_showcase/ui_showcase.dart';

/// A view that displays a list of showcase nodes.
///
/// See more:
/// - [ShowcaseMobile]
/// - [ShowcaseDesktop]
class ShowcaseView extends StatefulWidget {
  const ShowcaseView({
    required this.nodes,
    required this.navigator,
  });

  final List<ShowcaseNode> nodes;
  final Widget navigator;

  @override
  State<ShowcaseView> createState() => _ShowcaseViewState();
}

class _ShowcaseViewState extends State<ShowcaseView> {
  void _onNodeSelected(ShowcaseNode node) {
    ActiveNodeNotifier.of(context, listen: false).updateActiveNode(node);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    Widget child;

    if (size.width < 600) {
      child = ShowcaseMobile(
        navigator: widget.navigator,
        nodes: widget.nodes,
        onNodeSelected: _onNodeSelected,
      );
    } else {
      child = ShowcaseDesktop(
        navigator: widget.navigator,
        nodes: widget.nodes,
        onNodeSelected: _onNodeSelected,
      );
    }

    return child;
  }
}

class ShowcaseMobile extends StatelessWidget {
  const ShowcaseMobile({
    required this.navigator,
    required this.nodes,
    required this.onNodeSelected,
    super.key,
  });

  final List<ShowcaseNode> nodes;
  final ValueChanged<ShowcaseNode> onNodeSelected;
  final Widget navigator;

  @override
  Widget build(BuildContext context) {
    final activeNode = ActiveNodeNotifier.of(context).activeNode;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      drawer: Drawer(
        child: ShowcaseTreeView(
          nodes: nodes,
          selectedNode: activeNode,
          width: 304,
          onNodeSelected: (value) {
            onNodeSelected(value);
            Navigator.pop(context);
          },
        ),
      ),
      body: navigator,
      // body: Builder(
      //   builder: (context) {
      //     return Column(
      //       crossAxisAlignment: CrossAxisAlignment.start,
      //       children: [
      //         Padding(
      //           padding: const EdgeInsets.all(4),
      //           child: Row(
      //             children: [
      //               IconButton(
      //                 icon: const Icon(Icons.menu_rounded),
      //                 onPressed: () {
      //                   Scaffold.of(context).openDrawer();
      //                 },
      //               ),
      //               if (activeNode case final activeNode?) ActiveNodeMetadata(node: activeNode),
      //             ],
      //           ),
      //         ),
      //         Expanded(child: navigator),
      //       ],
      //     );
      //   },
      // ),
    );
  }
}

class ShowcaseDesktop extends StatelessWidget {
  const ShowcaseDesktop({
    required this.navigator,
    required this.nodes,
    required this.onNodeSelected,
    super.key,
  });

  final List<ShowcaseNode> nodes;
  final ValueChanged<ShowcaseNode> onNodeSelected;
  final Widget navigator;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Row(
        children: [
          SizedBox(
            width: 200,
            child: ShowcaseTreeView(
              nodes: nodes,
              onNodeSelected: onNodeSelected,
              selectedNode: ActiveNodeNotifier.of(context).activeNode,
            ),
          ),
          Expanded(child: navigator),
        ],
      ),
    );
  }
}
