import 'package:flutter/material.dart';

/// {@template window_size}
/// Breakpoints for responsive design.
///
/// The [WindowSize] class represents a breakpoint for responsive design.
/// {@endtemplate}
extension type const WindowSize(Size _size) implements Size {
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

  /// Maps the [WindowSize] to a value of type [T].
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

  /// Returns values based on the [WindowSize] with a fallback to the lower size,
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

/// Scope that provides [WindowSize] to its descendants.
class WindowSizeScope extends StatelessWidget {
  /// Creates a [WindowSizeScope] that provides [WindowSize] to its descendants.
  const WindowSizeScope({required this.child, super.key});

  /// The widget below this widget in the tree.
  final Widget child;

  /// Returns the [WindowSize] of the nearest [WindowSizeScope] ancestor.
  static WindowSize of(BuildContext context, {bool listen = true}) {
    final windowSize = listen
        ? context.dependOnInheritedWidgetOfExactType<_InheritedWindowSize>()?.windowSize
        : context.getInheritedWidgetOfExactType<_InheritedWindowSize>()?.windowSize;

    if (windowSize == null) {
      throw Exception('WindowSizeScope not found in context');
    }

    return windowSize;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return _InheritedWindowSize(windowSize: WindowSize(size), child: child);
  }
}

class _InheritedWindowSize extends InheritedWidget {
  const _InheritedWindowSize({required this.windowSize, required super.child});

  /// The [WindowSize] provided by this scope.
  final WindowSize windowSize;

  @override
  bool updateShouldNotify(_InheritedWindowSize oldWidget) => windowSize != oldWidget.windowSize;
}
