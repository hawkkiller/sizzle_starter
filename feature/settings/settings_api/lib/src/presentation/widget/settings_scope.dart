import 'dart:async';

import 'package:flutter/material.dart';
import 'package:settings_api/settings_api.dart';

class SettingsScope extends StatefulWidget {
  const SettingsScope({
    required this.settingsContainer,
    required this.child,
    super.key,
  });

  final SettingsContainer settingsContainer;
  final Widget child;

  /// Get the current settings state from the settings scope.
  static SettingsInherited of(BuildContext context, {bool listen = true}) {
    final settingsScope = listen
        ? context.dependOnInheritedWidgetOfExactType<SettingsInherited>()
        : context.getInheritedWidgetOfExactType<SettingsInherited>();

    if (settingsScope == null) {
      throw Exception('SettingsScope not found');
    }

    return settingsScope;
  }

  /// Get the settings container from the settings scope.
  static SettingsContainer containerOf(BuildContext context, {bool listen = true}) {
    final settingsScope = of(context, listen: listen);

    return settingsScope.settingsContainer;
  }

  /// Get the settings bloc from the settings scope.
  static SettingsBloc blocOf(BuildContext context, {bool listen = true}) {
    final settingsScope = of(context, listen: listen);

    return settingsScope.settingsContainer.settingsBloc;
  }

  /// Get the settings state from the settings scope.
  static SettingsState stateOf(BuildContext context, {bool listen = true}) {
    final settingsScope = of(context, listen: listen);
    return settingsScope.state;
  }

  /// Get the settings from the settings scope.
  static Settings settingsOf(BuildContext context, {bool listen = true}) {
    final settingsScope = of(context, listen: listen);
    return settingsScope.state.settings ?? Settings.initial;
  }

  @override
  State<SettingsScope> createState() => _SettingsScopeState();
}

class _SettingsScopeState extends State<SettingsScope> {
  late final StreamSubscription<SettingsState> _subscription;
  late SettingsState _state;

  @override
  void initState() {
    super.initState();
    _state = widget.settingsContainer.settingsBloc.state;
    _subscription = widget.settingsContainer.settingsBloc.stream.listen((state) {
      setState(() {
        _state = state;
      });
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SettingsInherited(
      settingsContainer: widget.settingsContainer,
      state: _state,
      child: widget.child,
    );
  }
}

class SettingsInherited extends InheritedWidget {
  const SettingsInherited({
    required this.settingsContainer,
    required this.state,
    required super.child,
    super.key,
  });

  final SettingsContainer settingsContainer;
  final SettingsState state;

  @override
  bool updateShouldNotify(SettingsInherited oldWidget) {
    return state != oldWidget.state;
  }
}
