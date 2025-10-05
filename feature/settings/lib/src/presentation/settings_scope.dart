import 'package:common/common.dart';
import 'package:flutter/widgets.dart';
import 'package:settings/settings.dart';

/// A scope that provides [SettingsContainer] to its widget subtree.
class SettingsScope extends InheritedWidget {
  const SettingsScope({
    required this.settingsContainer,
    required super.child,
    super.key,
  });

  /// Container with settings.
  final SettingsContainer settingsContainer;

  /// Get the settings from the [context].
  static SettingsContainer of(BuildContext context) =>
      context.inhOf<SettingsScope>(listen: false).settingsContainer;

  @override
  bool updateShouldNotify(covariant SettingsScope oldWidget) {
    return !identical(settingsContainer, oldWidget.settingsContainer);
  }
}
