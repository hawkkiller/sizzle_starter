import 'package:flutter/material.dart';
import 'package:ui_showcase/src/widget/restoration/page_storage_reader.dart';
import 'package:ui_showcase/ui_showcase.dart';

class BooleanInput extends StatefulWidget with InputWidget {
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
  State<BooleanInput> createState() => _BooleanInputState();
}

class _BooleanInputState extends State<BooleanInput> with PageStorageReader<BooleanInput, bool> {
  @override
  Object? obtainPageStorageIdentifier() {
    final node = ActiveNodeNotifier.of(context, listen: false).activeNode;

    return '${node?.fullPath}-${widget.label}-boolean-input';
  }

  @override
  void restoreState(bool data) {
    widget.notifier.value = data;
  }

  void _onChanged(bool value) {
    widget.notifier.value = value;
    writeStoredData(value);
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
        Text(widget.label, style: textTheme.labelLarge),
        ValueListenableBuilder(
          valueListenable: widget.notifier,
          builder: (context, value, child) {
            return Switch(value: value, onChanged: _onChanged);
          },
        ),
        if (widget.description case final description?)
          Text(
            description,
            style: textTheme.bodySmall?.copyWith(color: colorScheme.secondary),
          ),
      ],
    );
  }
}
