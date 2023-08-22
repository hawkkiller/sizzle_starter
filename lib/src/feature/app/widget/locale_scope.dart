import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sizzle_starter/src/core/utils/mixin/scope_mixin.dart';
import 'package:sizzle_starter/src/feature/app/logic/locale_bloc.dart';
import 'package:sizzle_starter/src/feature/initialization/widget/dependencies_scope.dart';

/// {@template theme_controller}
/// A controller that holds and operates the app locale.
/// {@endtemplate}
abstract interface class LocaleController {
  /// Get the current locale.
  ///
  /// This is handy to be obtained in the [MaterialApp].
  Locale get locale;

  /// Set the locale to [locale].
  void setLocale(Locale locale);
}

/// [LocaleScope] is responsible for handling locale-related stuff.
///
/// Provides a [LocaleController] to hold and operate the app locale.
///
/// The [LocaleController] can be obtained using the static method [of], which
/// returns the [LocaleController] of the closest [LocaleScope] ancestor.
///
/// The [LocaleScope] is implemented as a [StatefulWidget] with a [State] that
/// implements the [LocaleController] interface. The [State] subscribes to the
/// [LocaleBloc] to listen for changes in the locale state, and updates the
/// [LocaleController] with the new locale when it changes.
class LocaleScope extends StatefulWidget {
  /// Creates a new [LocaleScope] with the given child widget.
  const LocaleScope({
    required this.child,
    super.key,
  });

  /// The child widget.
  final Widget child;

  /// Returns the [LocaleController] of the closest [LocaleScope] ancestor.
  ///
  /// If [listen] is true (the default), the returned [LocaleController] will
  /// rebuild the widget when the locale changes. If [listen] is false, the
  /// returned [LocaleController] will not rebuild the widget when the locale
  /// changes.
  static LocaleController of(BuildContext context, {bool listen = true}) =>
      ScopeMixin.scopeOf<_LocaleInherited>(context, listen: listen).controller;

  @override
  State<LocaleScope> createState() => _LocaleScopeState();
}

/// The [State] of the [LocaleScope] widget.
///
/// Implements the [LocaleController] interface to hold and operate the app
/// locale.
class _LocaleScopeState extends State<LocaleScope> implements LocaleController {
  late LocaleState _state;

  late final LocaleBloc _bloc;

  StreamSubscription<void>? _subscription;

  /// Listener for changes in the locale state.
  ///
  /// Updates the [_state] with the new locale state, and rebuilds the widget.
  void _listener(LocaleState state) {
    if (_state == state) return;

    setState(() => _state = state);
  }

  @override
  void initState() {
    _bloc = LocaleBloc(
      localeRepository: DependenciesScope.of(context).localeRepository,
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
    properties.add(DiagnosticsProperty<Locale>('locale', locale));
  }

  @override
  void setLocale(Locale locale) => _bloc.add(
        LocaleEvent.update(locale),
      );

  @override
  Locale get locale => _state.locale;

  @override
  Widget build(BuildContext context) => _LocaleInherited(
        controller: this,
        state: _state,
        child: widget.child,
      );
}

/// An [InheritedWidget] that holds the [LocaleController] and the current
/// locale state.
class _LocaleInherited extends InheritedWidget {
  const _LocaleInherited({
    required this.controller,
    required this.state,
    required super.child,
  });

  /// The [LocaleController] to hold and operate the app locale.
  final LocaleController controller;

  /// The current locale state.
  final LocaleState state;

  @override
  bool updateShouldNotify(covariant _LocaleInherited oldWidget) =>
      oldWidget.state != state;
}
