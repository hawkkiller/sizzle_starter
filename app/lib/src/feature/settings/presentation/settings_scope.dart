import 'package:common_utils/common_utils.dart';
import 'package:flutter/widgets.dart';
import 'package:sizzle_starter/src/feature/settings/domain/model/settings.dart';
import 'package:sizzle_starter/src/widget/dependencies_scope.dart';

/// A scope that provides [Settings] to the application.
class SettingsScope extends StatelessWidget {
  const SettingsScope({required this.child, super.key});

  /// The widget below this widget in the tree.
  final Widget child;

  /// Returns the [Settings] of the nearest [SettingsScope] ancestor.
  static Settings of(BuildContext context, {bool listen = true}) =>
      context.inhOf<_SettingsInherited>(listen: listen).settings;

  /// Update the [Settings] of the nearest [SettingsScope] ancestor.
  static Future<void> update(BuildContext context, Settings Function(Settings) transform) async {
    final settingsService = DependenciesScope.of(context).settingsContainer.settingsService;
    await settingsService.update(transform);
  }

  @override
  Widget build(BuildContext context) {
    final settingsService = DependenciesScope.of(context).settingsContainer.settingsService;

    return StreamBuilder<Settings>(
      stream: settingsService.stream,
      initialData: settingsService.current,
      builder: (context, snapshot) {
        return _SettingsInherited(settings: snapshot.data!, child: child);
      },
    );
  }
}

class _SettingsInherited extends InheritedWidget {
  const _SettingsInherited({required super.child, required this.settings});

  final Settings settings;

  @override
  bool updateShouldNotify(covariant _SettingsInherited oldWidget) {
    return settings != oldWidget.settings;
  }
}
