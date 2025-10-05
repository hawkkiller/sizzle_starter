import 'package:example/src/widget/component_preview.dart';
import 'package:flutter/material.dart';
import 'package:ui_showcase/ui_showcase.dart';

class SomeButtonPreview extends StatefulWidget {
  const SomeButtonPreview({super.key});

  @override
  State<SomeButtonPreview> createState() => _SomeButtonPreviewState();
}

class _SomeButtonPreviewState extends State<SomeButtonPreview> {
  final _labelController = TextEditingController(text: 'Click Me!');
  final _enabledController = ValueNotifier(true);

  @override
  Widget build(BuildContext context) {
    return ComponentPreview(
      inputs: [
        StringInput(
          label: 'Label',
          description: 'The label of the button',
          controller: _labelController,
        ),
        BooleanInput(
          label: 'Enabled',
          description: 'Whether the button is enabled',
          notifier: _enabledController,
        ),
      ],
      builder: (context) {
        return ElevatedButton(
          onPressed: _enabledController.value ? () {} : null,
          child: Text(_labelController.text),
        );
      },
    );
  }
}
