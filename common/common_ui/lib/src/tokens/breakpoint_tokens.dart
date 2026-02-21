import 'package:flutter/material.dart';

/// {@template ui_breakpoint}
/// Breakpoints for responsive design.
///
/// The [UiBreakpoint] class represents a breakpoint for responsive design.
/// {@endtemplate}
extension type const UiBreakpoint(Size _size) implements Size {
  static const _medium = 600.0;
  static const _expanded = 840.0;
  static const _large = 1200.0;
  static const _extraLarge = 1600.0;

  /// Returns true if the window size is compact.
  bool get isCompact => maybeMap(orElse: () => false, compact: () => true);

  /// Returns true if the window size is medium.
  bool get isMedium => maybeMap(orElse: () => false, medium: () => true);

  /// Returns true if the window size is medium or larger.
  bool get isMediumOrLarger => maybeMap(orElse: () => true, compact: () => false);

  /// Returns true if the window size is expanded.
  bool get isExpanded => maybeMap(orElse: () => false, expanded: () => true);

  /// Returns true if the window size is expanded or larger.
  bool get isExpandedOrLarger =>
      maybeMap(orElse: () => true, compact: () => false, medium: () => false);

  /// Returns true if the window size is large.
  bool get isLarge => maybeMap(orElse: () => false, large: () => true);

  /// Returns true if the window size is large or larger.
  bool get isLargeOrLarger =>
      maybeMap(orElse: () => false, large: () => true, extraLarge: () => true);

  /// Returns true if the window size is extra large.
  bool get isExtraLarge => maybeMap(orElse: () => false, extraLarge: () => true);

  /// Maps the [UiBreakpoint] to a value of type [T].
  T map<T>({
    required T Function() compact,
    required T Function() medium,
    required T Function() expanded,
    required T Function() large,
    required T Function() extraLarge,
  }) => switch (_size.width) {
    < _medium => compact(),
    < _expanded => medium(),
    < _large => expanded(),
    < _extraLarge => large(),
    _ => extraLarge(),
  };

  /// If value is not provided, returns the result of the [orElse] function.
  T maybeMap<T>({
    required T Function() orElse,
    T Function()? compact,
    T Function()? medium,
    T Function()? expanded,
    T Function()? large,
    T Function()? extraLarge,
  }) => map(
    compact: compact ?? orElse,
    medium: medium ?? orElse,
    expanded: expanded ?? orElse,
    large: large ?? orElse,
    extraLarge: extraLarge ?? orElse,
  );

  /// Returns values based on the [UiBreakpoint] with a fallback to the lower size,
  /// if the value is not provided.
  T mapWithLowerFallback<T>({
    required T Function() compact,
    T Function()? medium,
    T Function()? expanded,
    T Function()? large,
    T Function()? extraLarge,
  }) => map(
    compact: compact,
    medium: medium ?? compact,
    expanded: expanded ?? medium ?? compact,
    large: large ?? expanded ?? medium ?? compact,
    extraLarge: extraLarge ?? large ?? expanded ?? medium ?? compact,
  );
}

/// Scope that provides [UiBreakpoint] to its descendants.
class UiBreakpointScope extends StatelessWidget {
  /// Creates a [UiBreakpointScope] that provides [UiBreakpoint] to its descendants.
  const UiBreakpointScope({required this.child, super.key});

  /// The widget below this widget in the tree.
  final Widget child;

  /// Returns the [UiBreakpoint] of the nearest [UiBreakpointScope] ancestor.
  static UiBreakpoint of(BuildContext context, {bool listen = true}) {
    final breakpoint = listen
        ? context.dependOnInheritedWidgetOfExactType<_InheritedUiBreakpoint>()?.breakpoint
        : context.getInheritedWidgetOfExactType<_InheritedUiBreakpoint>()?.breakpoint;

    if (breakpoint == null) {
      throw Exception('UiBreakpointScope not found in context');
    }

    return breakpoint;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return _InheritedUiBreakpoint(breakpoint: UiBreakpoint(size), child: child);
  }
}

class _InheritedUiBreakpoint extends InheritedWidget {
  const _InheritedUiBreakpoint({required this.breakpoint, required super.child});

  /// The [UiBreakpoint] provided by this scope.
  final UiBreakpoint breakpoint;

  @override
  bool updateShouldNotify(_InheritedUiBreakpoint oldWidget) => breakpoint != oldWidget.breakpoint;
}
