import 'package:example/src/previews/button_preview.dart';
import 'package:flutter/material.dart';
import 'package:ui_showcase/ui_showcase.dart';

final showcaseNodes = [
  ShowcaseFolderNode(
    name: 'Button',
    children: [
      ShowcasePreviewNode(
        name: 'Variant 1',
        widget: const SomeButtonPreview(),
      ),
      ShowcasePreviewNode(
        name: 'Variant 2',
        widget: const SomeButtonPreview(),
      ),
    ],
  ),
];

class ShowcaseRoot extends StatelessWidget {
  const ShowcaseRoot({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          SizedBox(width: 200, child: ShowcaseTreeView(nodes: showcaseNodes)),
          Expanded(child: Container(color: Colors.red)),
        ],
      ),
    );
  }
}
