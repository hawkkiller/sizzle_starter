import 'package:flutter/material.dart';
import 'package:ui_showcase/src/widget/restoration/page_storage_reader.dart';
import 'package:ui_showcase/ui_showcase.dart';

class IntegerInput extends StatefulWidget with InputWidget {
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
  Listenable get listenable => notifier;

  @override
  State<IntegerInput> createState() => _IntegerInputState();
}

class _IntegerInputState extends State<IntegerInput> with PageStorageReader<IntegerInput, int> {
  @override
  Object? obtainPageStorageIdentifier() {
    final node = ActiveNodeNotifier.of(context, listen: false).activeNode;

    return '${node?.fullPath}-${widget.label}-integer-input';
  }

  @override
  void restoreState(int data) {
    widget.notifier.value = data;
  }

  void _onChange(double value) {
    widget.notifier.value = value.toInt();
    writeStoredData(value.toInt());
  }

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
          widget.label,
          style: textTheme.labelLarge?.copyWith(color: colorScheme.onSurface),
        ),
        ValueListenableBuilder(
          valueListenable: widget.notifier,
          builder: (context, value, child) {
            return SliderTheme(
              data: const SliderThemeData(showValueIndicator: ShowValueIndicator.always),
              child: Slider(
                value: value.toDouble(),
                min: widget.min?.toDouble() ?? 0,
                max: widget.max?.toDouble() ?? 100,
                label: value.toString(),
                onChanged: _onChange,
                onChangeEnd: _onChange,
              ),
            );
          },
        ),
        if (widget.description case final description?)
          Text(
            description,
            style: textTheme.bodySmall?.copyWith(color: colorScheme.outline),
          ),
      ],
    );
  }
}
