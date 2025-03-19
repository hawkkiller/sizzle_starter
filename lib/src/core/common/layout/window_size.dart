import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sizzle_starter/src/core/common/extensions/context_extension.dart';

/// {@template window_size}
/// Breakpoints for responsive design.
///
/// The [WindowSize] class represents a breakpoint for responsive design.
/// {@endtemplate}
sealed class WindowSize extends Size {
  /// {@macro window_size}
  WindowSize(super.source) : super.copy();

  /// Creates a [WindowSize] from the given [Size].
  factory WindowSize.fromSize(Size size) {
    assert(size.width >= 0, 'Width must be greater than or equal to 0');

    return switch (size.width) {
      >= _compact && < _medium => WindowSizeCompact(size),
      >= _medium && < _expanded => WindowSizeMedium(size),
      >= _expanded && < _large => WindowSizeExpanded(size),
      >= _large && < _extraLarge => WindowSizeLarge(size),
      _ => WindowSizeExtraLarge(size),
    };
  }

  static const _compact = 0;
  static const _medium = 600;
  static const _expanded = 840;
  static const _large = 1200;
  static const _extraLarge = 1600;

  /// Returns true if the window size is compact.
  bool get isCompact => maybeMap(orElse: () => false, compact: (_) => true);

  /// Returns true if the window size is medium.
  bool get isMedium => maybeMap(orElse: () => false, medium: (_) => true);

  /// Returns true if the window size is medium or larger.
  bool get isMediumOrLarger => maybeMap(
    orElse: () => false,
    medium: (_) => true,
    expanded: (_) => true,
    large: (_) => true,
    extraLarge: (_) => true,
  );

  /// Returns true if the window size is expanded.
  bool get isExpanded => maybeMap(orElse: () => false, expanded: (_) => true);

  /// Returns true if the window size is expanded or larger.
  bool get isExpandedOrLarger => maybeMap(
    orElse: () => false,
    expanded: (_) => true,
    large: (_) => true,
    extraLarge: (_) => true,
  );

  /// Returns true if the window size is large.
  bool get isLarge => maybeMap(orElse: () => false, large: (_) => true);

  /// Returns true if the window size is large or larger.
  bool get isLargeOrLarger =>
      maybeMap(orElse: () => false, large: (_) => true, extraLarge: (_) => true);

  /// Returns true if the window size is extra large.
  bool get isExtraLarge => maybeMap(orElse: () => false, extraLarge: (_) => true);

  /// Maps the [WindowSize] to a value of type [T].
  T map<T>({
    required T Function(WindowSizeCompact) compact,
    required T Function(WindowSizeMedium) medium,
    required T Function(WindowSizeExpanded) expanded,
    required T Function(WindowSizeLarge) large,
    required T Function(WindowSizeExtraLarge) extraLarge,
  }) => switch (this) {
    final WindowSizeCompact size => compact(size),
    final WindowSizeMedium size => medium(size),
    final WindowSizeExpanded size => expanded(size),
    final WindowSizeLarge size => large(size),
    final WindowSizeExtraLarge size => extraLarge(size),
  };

  /// Maps the [WindowSize] to a value of type [T] or returns [orElse] if the [WindowSize] is not matched.
  T maybeMap<T>({
    required T Function() orElse,
    T Function(WindowSizeCompact)? compact,
    T Function(WindowSizeMedium)? medium,
    T Function(WindowSizeExpanded)? expanded,
    T Function(WindowSizeLarge)? large,
    T Function(WindowSizeExtraLarge)? extraLarge,
  }) => map(
    compact: compact ?? (_) => orElse(),
    medium: medium ?? (_) => orElse(),
    expanded: expanded ?? (_) => orElse(),
    large: large ?? (_) => orElse(),
    extraLarge: extraLarge ?? (_) => orElse(),
  );
}

/// Compact breakpoint for responsive design.
final class WindowSizeCompact extends WindowSize {
  /// Creates a [WindowSizeCompact] breakpoint.
  WindowSizeCompact(super.source) 
    : assert(
        source.width >= WindowSize._compact && source.width < WindowSize._medium,
        'Width must be between ${WindowSize._compact} and ${WindowSize._medium}',
      );

  @override
  bool operator ==(Object other) =>
      other is WindowSizeCompact && width == other.width && height == other.height;

  @override
  int get hashCode => Object.hashAll([width, height]);

  @override
  String toString() => 'WindowSizeCompact';
}

/// Medium breakpoint for responsive design.
final class WindowSizeMedium extends WindowSize {
  /// Creates a [WindowSizeMedium] breakpoint.
  WindowSizeMedium(super.source)
    : assert(
        source.width >= WindowSize._medium && source.width < WindowSize._expanded,
        'Width must be between ${WindowSize._medium} and ${WindowSize._expanded}',
      );

  @override
  bool operator ==(Object other) =>
      other is WindowSizeMedium && width == other.width && height == other.height;

  @override
  int get hashCode => Object.hashAll([width, height]);

  @override
  String toString() => 'WindowSizeMedium';
}

/// Expanded breakpoint for responsive design.
final class WindowSizeExpanded extends WindowSize {
  /// Creates a [WindowSizeExpanded] breakpoint.
  WindowSizeExpanded(super.source)
    : assert(
        source.width >= WindowSize._expanded && source.width < WindowSize._large,
        'Width must be between ${WindowSize._expanded} and ${WindowSize._large}',
      );

  @override
  bool operator ==(Object other) =>
      other is WindowSizeExpanded && width == other.width && height == other.height;

  @override
  int get hashCode => Object.hashAll([width, height]);

  @override
  String toString() => 'WindowSizeExpanded';
}

/// Large breakpoint for responsive design.
final class WindowSizeLarge extends WindowSize {
  /// Creates a [WindowSizeLarge] breakpoint.
  WindowSizeLarge(super.source)
    : assert(
        source.width >= WindowSize._large && source.width < WindowSize._extraLarge,
        'Width must be between ${WindowSize._large} and ${WindowSize._extraLarge}',
      );

  @override
  bool operator ==(Object other) =>
      other is WindowSizeLarge && width == other.width && height == other.height;

  @override
  int get hashCode => Object.hashAll([width, height]);

  @override
  String toString() => 'WindowSizeLarge';
}

/// Extra large breakpoint for responsive design.
final class WindowSizeExtraLarge extends WindowSize {
  /// Creates a [WindowSizeExtraLarge] breakpoint.
  WindowSizeExtraLarge(super.source)
    : assert(
        source.width >= WindowSize._extraLarge,
        'Width must be greater than or equal to ${WindowSize._extraLarge}',
      );

  @override
  bool operator ==(Object other) =>
      other is WindowSizeExtraLarge && width == other.width && height == other.height;

  @override
  int get hashCode => Object.hashAll([width, height]);

  @override
  String toString() => 'WindowSizeExtraLarge';
}

/// Scope that provides [WindowSize] to its descendants.
class WindowSizeScope extends StatefulWidget {
  /// Creates a [WindowSizeScope] that provides [WindowSize] to its descendants.
  const WindowSizeScope({required this.child, super.key})

  /// The widget below this widget in the tree.
  final Widget child;

  /// Returns the [WindowSize] of the nearest [WindowSizeScope] ancestor.
  static WindowSize of(BuildContext context, {bool listen = true}) =>
      context.inhOf<_InheritedWindowSize>(listen: listen).windowSize;

  @override
  State<WindowSizeScope> createState() => _WindowSizeScopeState();
}

class _WindowSizeScopeState extends State<WindowSizeScope> with WidgetsBindingObserver {
  late WindowSize _windowSize;

  WindowSize _getWindowSize() {
    final view = PlatformDispatcher.instance.views.first;
    return WindowSize.fromSize(view.physicalSize / view.devicePixelRatio);
  }

  @override
  void initState() {
    super.initState();

    _windowSize = _getWindowSize();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeMetrics() {
    final windowSize = _getWindowSize();

    if (_windowSize != windowSize) {
      setState(() => _windowSize = windowSize);
    }
    super.didChangeMetrics();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      _InheritedWindowSize(windowSize: _windowSize, child: widget.child);
}

class _InheritedWindowSize extends InheritedWidget {
  const _InheritedWindowSize({required this.windowSize, required super.child});

  /// The [WindowSize] provided by this scope.
  final WindowSize windowSize;

  @override
  bool updateShouldNotify(_InheritedWindowSize oldWidget) => windowSize != oldWidget.windowSize;
}
