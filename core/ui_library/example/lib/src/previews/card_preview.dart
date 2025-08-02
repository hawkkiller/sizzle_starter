import 'package:flutter/material.dart';
import 'package:ui_showcase/ui_showcase.dart';

class SomeCardPreview extends StatefulWidget {
  const SomeCardPreview({super.key});

  @override
  State<SomeCardPreview> createState() => _SomeCardPreviewState();
}

class _SomeCardPreviewState extends State<SomeCardPreview> {
  final _controller = TextEditingController(text: 'Card');

  @override
  Widget build(BuildContext context) {
    return ComponentPreview(
      listenables: [_controller],
      inputs: [
        StringInput(
          label: 'Label',
          description: 'The label of the button',
          controller: _controller,
        ),
      ],
      builder: (context) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(_controller.text),
          ),
        );
      },
    );
  }
}
