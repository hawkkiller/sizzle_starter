import 'package:flutter/material.dart';

class IntegerInput extends StatelessWidget {
  const IntegerInput({
    required this.notifier,
    required this.label,
    this.description,
    this.min,
    this.max,
  });

  final ValueNotifier<int> notifier;
  final String label;
  final int? min;
  final int? max;
  final String? description;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: textTheme.labelLarge?.copyWith(color: colorScheme.onSurface),
        ),
        ValueListenableBuilder(
          valueListenable: notifier,
          builder: (context, value, child) {
            return SliderTheme(
              data: const SliderThemeData(showValueIndicator: ShowValueIndicator.always),
              child: Slider(
                value: value.toDouble(),
                min: min?.toDouble() ?? 0,
                max: max?.toDouble() ?? 100,
                label: value.toString(),
                onChanged: (value) => notifier.value = value.toInt(),
              ),
            );
          },
        ),
        if (description case final description?)
          Text(
            description,
            style: textTheme.bodySmall?.copyWith(color: colorScheme.outline),
          ),
      ],
    );
  }
}
