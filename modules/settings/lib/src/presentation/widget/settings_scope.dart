import 'package:flutter/widgets.dart';
import 'package:settings/settings.dart';

/// {@template settings_scope}
/// SettingsScope widget.
/// {@endtemplate}
class SettingsScope extends StatelessWidget {
  /// {@macro settings_scope}
  const SettingsScope({
    required this.settingsContainer,
    required this.child,
    super.key,
  });

  final SettingsContainer settingsContainer;
  final Widget child;

  /// Get the [SettingsBloc] instance.
  static SettingsBloc of(BuildContext context, {bool listen = true}) {
    final settingsScope = listen
        ? context.dependOnInheritedWidgetOfExactType<_InheritedSettings>()
        : context.getInheritedWidgetOfExactType<_InheritedSettings>();
    return settingsScope!.settingsContainer.settingsBloc;
  }

  /// Get the [Settings] instance.
  static Settings settingsOf(BuildContext context, {bool listen = true}) {
    final settingsScope = listen
        ? context.dependOnInheritedWidgetOfExactType<_InheritedSettings>()
        : context.getInheritedWidgetOfExactType<_InheritedSettings>();
    return settingsScope!.settings ?? const Settings();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<SettingsState>(
      stream: settingsContainer.settingsBloc.stream,
      builder: (context, state) {
        final data = state.data;

        return _InheritedSettings(
          settingsContainer: settingsContainer,
          settings: data?.settings,
          child: child,
        );
      },
    );
  }
}

/// {@template inherited_settings}
/// _InheritedSettings widget.
/// {@endtemplate}
class _InheritedSettings extends InheritedWidget {
  /// {@macro inherited_settings}
  const _InheritedSettings({
    required super.child,
    required this.settingsContainer,
    required this.settings,
  });

  final SettingsContainer settingsContainer;
  final Settings? settings;

  @override
  bool updateShouldNotify(covariant _InheritedSettings oldWidget) => settings != oldWidget.settings;
}
