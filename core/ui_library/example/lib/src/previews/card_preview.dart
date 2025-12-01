import 'package:example/src/widget/component_preview.dart';
import 'package:flutter/material.dart';
import 'package:ui_showcase/ui_showcase.dart';

class CardPreview extends StatefulWidget {
  const CardPreview({super.key});

  @override
  State<CardPreview> createState() => _CardPreviewState();
}

class _CardPreviewState extends State<CardPreview> {
  final _controller = TextEditingController(text: 'Card');

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
