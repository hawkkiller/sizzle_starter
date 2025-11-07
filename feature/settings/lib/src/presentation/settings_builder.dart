import 'package:flutter/material.dart';
import 'package:settings/settings.dart';

/// Widget that rebuilds when settings change.
class SettingsBuilder extends StatefulWidget {
  const SettingsBuilder({required this.builder, super.key});

  final Widget Function(BuildContext context, Settings settings) builder;

  @override
  State<SettingsBuilder> createState() => _SettingsBuilderState();
}

class _SettingsBuilderState extends State<SettingsBuilder> {
  @override
  Widget build(BuildContext context) {
    final service = SettingsScope.of(context).settingsService;

    return StreamBuilder(
      stream: service.stream,
      initialData: service.current,
      builder: (context, snapshot) {
        return widget.builder(context, snapshot.data ?? const Settings());
      },
    );
  }
}
