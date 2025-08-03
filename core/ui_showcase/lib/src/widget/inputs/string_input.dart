import 'package:flutter/material.dart';
import 'package:ui_showcase/ui_showcase.dart';

class StringInput extends StatelessWidget with InputWidget {
  const StringInput({
    required this.label,
    required this.controller,
    this.description,
    this.hint,
  });

  final TextEditingController controller;
  final String label;
  final String? description;
  final String? hint;

  @override
  Listenable get listenable => controller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: label,
            hintText: hint,
          ),
        ),
        if (description case final description?)
          Text(
            description,
            style: textTheme.bodySmall?.copyWith(color: colorScheme.secondary),
          ),
      ],
    );
  }
}
