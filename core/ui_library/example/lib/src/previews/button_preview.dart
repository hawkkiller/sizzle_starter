import 'package:flutter/material.dart';
import 'package:ui_showcase/ui_showcase.dart';

class SomeButtonPreview extends StatelessWidget {
  const SomeButtonPreview({super.key});

  @override
  Widget build(BuildContext context) {
    final activeNode = ActiveNodeProvider.of(context).activeNode!;

    return Scaffold(
      appBar: AppBar(title: Text(activeNode.fullPath)),
      body: Center(
        child: ElevatedButton(
          onPressed: () {},
          child: const Text('Click me'),
        ),
      ),
    );
  }
}
