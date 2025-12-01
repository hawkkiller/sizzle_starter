import 'package:example/src/widget/component_preview.dart';
import 'package:flutter/material.dart';
import 'package:ui_showcase/ui_showcase.dart';

class CheckboxPreview extends StatefulWidget {
  const CheckboxPreview({super.key});

  @override
  State<CheckboxPreview> createState() => _CheckboxPreviewState();
}

class _CheckboxPreviewState extends State<CheckboxPreview> {
  final _enabledController = ValueNotifier(true);

  @override
  Widget build(BuildContext context) {
    return ComponentPreview(
      inputs: [
        BooleanInput(
          label: 'Value',
          description: 'The value of the checkbox',
          notifier: _enabledController,
        ),
      ],
      builder: (context) {
        return Checkbox(
          value: _enabledController.value,
          onChanged: (value) {
            _enabledController.value = value ?? false;
          },
        );
      },
    );
  }
}
