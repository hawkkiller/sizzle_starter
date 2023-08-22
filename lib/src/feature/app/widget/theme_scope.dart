import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sizzle_starter/src/core/utils/mixin/scope_mixin.dart';
import 'package:sizzle_starter/src/feature/app/logic/theme_bloc.dart';
import 'package:sizzle_starter/src/feature/app/model/app_theme.dart';
import 'package:sizzle_starter/src/feature/initialization/widget/dependencies_scope.dart';

/// {@template theme_controller}
/// A controller that holds and operates the app theme.
/// {@endtemplate}
abstract interface class ThemeController {
  /// Get the current theme.
  ///
  /// This is handy to be obtained in the [MaterialApp].
  AppTheme get theme;

  /// Set the theme to [theme].
  void setTheme(AppTheme theme);
}

/// {@template theme_scope}
/// Theme scope is responsible for handling theme-related stuff.
///
/// See [ThemeController] for more info.
/// {@endtemplate}
class ThemeScope extends StatefulWidget {
  /// {@macro theme_scope}
  const ThemeScope({
    required this.child,
    super.key,
  });

  /// The child widget.
  final Widget child;

  /// Get the [ThemeController] of the closest [ThemeScope] ancestor.
  static ThemeController of(BuildContext context, {bool listen = true}) =>
      ScopeMixin.scopeOf<_ThemeInherited>(context, listen: listen).controller;

  @override
  State<ThemeScope> createState() => _ThemeScopeState();
}

class _ThemeScopeState extends State<ThemeScope> implements ThemeController {
  @override
  void setTheme(AppTheme theme) => _bloc.add(
        ThemeEvent.update(theme),
      );

  @override
  AppTheme get theme => _state.theme;

  late ThemeState _state;

  late final ThemeBloc _bloc;

  StreamSubscription<void>? _subscription;

  void _listener(ThemeState state) {
    if (_state == state) return;

    setState(() => _state = state);
  }

  @override
  void initState() {
    _bloc = ThemeBloc(
      DependenciesScope.of(context).themeRepository,
    );

    _state = _bloc.state;

    _subscription = _bloc.stream.listen(_listener);
    super.initState();
  }

  @override
  void dispose() {
    _bloc.close();
    _subscription?.cancel();
    super.dispose();
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<AppTheme>('theme', theme));
  }

  @override
  Widget build(BuildContext context) => _ThemeInherited(
        controller: this,
        state: _state,
        child: widget.child,
      );
}

class _ThemeInherited extends InheritedWidget {
  const _ThemeInherited({
    required this.controller,
    required this.state,
    required super.child,
  });

  /// {@macro theme_scope}
  final ThemeController controller;

  /// The current theme state.
  final ThemeState state;

  @override
  bool updateShouldNotify(covariant _ThemeInherited oldWidget) =>
      oldWidget.state != state;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      DiagnosticsProperty<ThemeState>('themeState', state),
    );
  }
}
