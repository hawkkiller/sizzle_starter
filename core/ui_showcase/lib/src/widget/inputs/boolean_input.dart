import 'package:flutter/material.dart';
import 'package:ui_showcase/ui_showcase.dart';

class BooleanInput extends StatelessWidget with InputWidget {
  const BooleanInput({
    required this.label,
    required this.notifier,
    this.description,
    super.key,
  });

  final String label;
  final String? description;
  final ValueNotifier<bool> notifier;

  @override
  Listenable get listenable => notifier;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: textTheme.labelLarge),
        ValueListenableBuilder(
          valueListenable: notifier,
          builder: (context, value, child) {
            return Switch(
              value: value,
              onChanged: (value) => notifier.value = value,
            );
          },
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
