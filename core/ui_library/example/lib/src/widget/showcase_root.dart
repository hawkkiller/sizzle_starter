import 'package:example/src/previews/button_preview.dart';
import 'package:flutter/material.dart';
import 'package:ui_showcase/ui_showcase.dart';

final showcaseNodes = [
  ShowcaseFolderNode(
    name: 'Button',
    children: [
      ShowcasePreviewNode(name: 'Variant 1', widget: const SomeButtonPreview()),
    ],
  ),
];

class ShowcaseRoot extends StatefulWidget {
  const ShowcaseRoot({super.key});

  @override
  State<ShowcaseRoot> createState() => _ShowcaseRootState();
}

class _ShowcaseRootState extends State<ShowcaseRoot> {
  ShowcaseNode? _selectedNode;

  void _onNodeSelected(ShowcaseNode node) {
    setState(() {
      _selectedNode = node;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          SizedBox(
            width: 200,
            child: ShowcaseTreeView(
              nodes: showcaseNodes,
              selectedNode: _selectedNode,
              onNodeSelected: _onNodeSelected,
            ),
          ),
          if (_selectedNode case final node?)
            ActiveNodeProvider(
              activeNode: node,
              child: Expanded(
                child: node.widget ?? const SizedBox.shrink(),
              ),
            ),
        ],
      ),
    );
  }
}
