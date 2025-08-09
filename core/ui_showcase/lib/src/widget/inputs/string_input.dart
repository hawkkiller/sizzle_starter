import 'package:flutter/material.dart';
import 'package:ui_showcase/src/widget/restoration/page_storage_reader.dart';
import 'package:ui_showcase/ui_showcase.dart';

class StringInput extends StatefulWidget with InputWidget {
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
  State<StringInput> createState() => _StringInputState();
}

class _StringInputState extends State<StringInput> with PageStorageReader<StringInput, String> {
  @override
  Object? obtainPageStorageIdentifier() {
    final node = ActiveNodeNotifier.of(context, listen: false).activeNode;

    return '${node?.fullPath}-${widget.label}-string-input';
  }

  @override
  void restoreState(String data) {
    widget.controller.text = data;
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
        TextField(
          controller: widget.controller,
          onChanged: writeStoredData,
          decoration: InputDecoration(
            labelText: widget.label,
            hintText: widget.hint,
          ),
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
