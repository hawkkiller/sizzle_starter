import 'package:example/src/widget/component_preview.dart';
import 'package:flutter/material.dart';
import 'package:ui_showcase/ui_showcase.dart';

class SomeButtonPreview extends StatefulWidget {
  const SomeButtonPreview({super.key});

  @override
  State<SomeButtonPreview> createState() => _SomeButtonPreviewState();
}

class _SomeButtonPreviewState extends State<SomeButtonPreview> {
  final _controller = TextEditingController(text: 'Click Me!');

  @override
  Widget build(BuildContext context) {
    return ComponentPreview(
      inputs: [
        StringInput(
          label: 'Label',
          description: 'The label of the button',
          controller: _controller,
        ),
      ],
      builder: (context) {
        return ElevatedButton(
          onPressed: () {},
          child: Text(_controller.text),
        );
      },
    );
  }
}
