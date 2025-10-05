import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:settings/settings.dart';

/// Widget that rebuilds when settings change.
class SettingsBuilder extends StatelessWidget {
  const SettingsBuilder({required this.builder, super.key});

  final Widget Function(BuildContext context, Settings settings) builder;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      bloc: SettingsScope.of(context).settingsBloc,
      builder: (context, state) {
        return builder(context, state.data);
      },
    );
  }
}
