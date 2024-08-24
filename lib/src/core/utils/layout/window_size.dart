import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sizzle_starter/src/core/utils/extensions/context_extension.dart';

/// A breakpoint that is used to determine the layout of the application.
///
/// It follows the Material Design guidelines for breakpoints.
///
/// See more:
/// - https://m3.material.io/foundations/layout/applying-layout
class WindowSize extends Size implements Comparable<WindowSize> {
  /// Creates a [WindowSize] with the given [width] and [height].
  WindowSize(super.width, super.height);

  /// Creates a [WindowSize] with the given [width] and [height].
  WindowSize.fromSize(super.source) : super.copy();

  /// Compact breakpoint
  static const compact = 0;

  /// Medium breakpoint
  static const medium = 600;

  /// Expanded breakpoint
  static const expanded = 840;

  /// Large breakpoint
  static const large = 1200;

  /// Extra large breakpoint
  static const extraLarge = 1600;

  /// Returns `true` if the viewport width is within the range of the compact breakpoint.
  bool get isCompact => maybeMap(
        compact: (_) => true,
        orElse: (_) => false,
      );

  /// Returns `true` if the viewport width is within the range of the compact breakpoint or bigger.
  bool get isCompactOrUp => maybeMap(
        orElse: (_) => true,
      );

  /// Returns `true` if the viewport width is within the range of the medium breakpoint.
  bool get isMedium => maybeMap(
        medium: (_) => true,
        orElse: (_) => false,
      );

  /// Returns `true` if the viewport width is within the range of the medium breakpoint or bigger.
  bool get isMediumOrUp => maybeMap(
        medium: (_) => true,
        expanded: (_) => true,
        large: (_) => true,
        extraLarge: (_) => true,
        orElse: (_) => false,
      );

  /// Returns `true` if the viewport width is within the range of the expanded breakpoint.
  bool get isExpanded => maybeMap(
        expanded: (_) => true,
        orElse: (_) => false,
      );

  /// Returns `true` if the viewport width is within the range of the expanded breakpoint or bigger.
  bool get isExpandedOrUp => maybeMap(
        expanded: (_) => true,
        large: (_) => true,
        extraLarge: (_) => true,
        orElse: (_) => false,
      );

  /// Returns `true` if the viewport width is within the range of the large breakpoint.
  bool get isLarge => maybeMap(
        large: (_) => true,
        orElse: (_) => false,
      );

  /// Returns `true` if the viewport width is within the range of the large breakpoint or bigger.
  bool get isLargeOrUp => maybeMap(
        large: (_) => true,
        extraLarge: (_) => true,
        orElse: (_) => false,
      );

  /// Returns `true` if the viewport width is within the range of the extra large breakpoint.
  bool get isExtraLarge => maybeMap(
        extraLarge: (_) => true,
        orElse: (_) => false,
      );

  /// Return value based on the current breakpoint.
  T map<T>({
    required T Function(WindowSize) compact,
    required T Function(WindowSize) medium,
    required T Function(WindowSize) expanded,
    required T Function(WindowSize) large,
    required T Function(WindowSize) extraLarge,
  }) =>
      switch (width) {
        >= WindowSize.extraLarge => extraLarge(this),
        >= WindowSize.large => large(this),
        >= WindowSize.expanded => expanded(this),
        >= WindowSize.medium => medium(this),
        _ => compact(this),
      };

  /// Return value based on the current breakpoint.
  T maybeMap<T>({
    required T Function(WindowSize) orElse,
    T Function(WindowSize)? compact,
    T Function(WindowSize)? medium,
    T Function(WindowSize)? expanded,
    T Function(WindowSize)? large,
    T Function(WindowSize)? extraLarge,
  }) =>
      map(
        compact: compact ?? orElse,
        medium: medium ?? orElse,
        expanded: expanded ?? orElse,
        large: large ?? orElse,
        extraLarge: extraLarge ?? orElse,
      );

  @override
  int compareTo(WindowSize other) {
    final compareWidth = width.compareTo(other.width);

    if (compareWidth != 0) {
      return compareWidth;
    }

    return height.compareTo(other.height);
  }
}

/// Scope that provides [WindowSize] to its descendants.
class WindowSizeScope extends StatefulWidget {
  /// Creates a [WindowSizeScope] that provides [WindowSize] to its descendants.
  const WindowSizeScope({
    required this.child,
    super.key,
  });

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
    _windowSize = _getWindowSize();
    WidgetsBinding.instance.addObserver(this);
    super.initState();
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
  Widget build(BuildContext context) => _InheritedWindowSize(
        windowSize: _windowSize,
        child: widget.child,
      );
}

class _InheritedWindowSize extends InheritedWidget {
  const _InheritedWindowSize({
    required this.windowSize,
    required super.child,
  });

  /// The [WindowSize] provided by this scope.
  final WindowSize windowSize;

  @override
  bool updateShouldNotify(_InheritedWindowSize oldWidget) => windowSize != oldWidget.windowSize;
}
