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
        compact: () => true,
        orElse: () => false,
      );

  /// Returns `true` if the viewport width is within the range of the compact breakpoint or bigger.
  bool get isCompactOrUp => maybeMap(
        orElse: () => true,
      );

  /// Returns `true` if the viewport width is within the range of the medium breakpoint.
  bool get isMedium => maybeMap(
        medium: () => true,
        orElse: () => false,
      );

  /// Returns `true` if the viewport width is within the range of the medium breakpoint or bigger.
  bool get isMediumOrUp => maybeMap(
        medium: () => true,
        expanded: () => true,
        large: () => true,
        extraLarge: () => true,
        orElse: () => false,
      );

  /// Returns `true` if the viewport width is within the range of the expanded breakpoint.
  bool get isExpanded => maybeMap(
        expanded: () => true,
        orElse: () => false,
      );

  /// Returns `true` if the viewport width is within the range of the expanded breakpoint or bigger.
  bool get isExpandedOrUp => maybeMap(
        expanded: () => true,
        large: () => true,
        extraLarge: () => true,
        orElse: () => false,
      );

  /// Returns `true` if the viewport width is within the range of the large breakpoint.
  bool get isLarge => maybeMap(
        large: () => true,
        orElse: () => false,
      );

  /// Returns `true` if the viewport width is within the range of the large breakpoint or bigger.
  bool get isLargeOrUp => maybeMap(
        large: () => true,
        extraLarge: () => true,
        orElse: () => false,
      );

  /// Returns `true` if the viewport width is within the range of the extra large breakpoint.
  bool get isExtraLarge => maybeMap(
        extraLarge: () => true,
        orElse: () => false,
      );

  /// Return value based on the current breakpoint.
  T map<T>({
    required T Function() compact,
    required T Function() medium,
    required T Function() expanded,
    required T Function() large,
    required T Function() extraLarge,
  }) =>
      switch (width) {
        >= WindowSize.extraLarge => extraLarge(),
        >= WindowSize.large => large(),
        >= WindowSize.expanded => expanded(),
        >= WindowSize.medium => medium(),
        _ => compact(),
      };

  /// Return value based on the current breakpoint.
  T maybeMap<T>({
    required T Function() orElse,
    T Function()? compact,
    T Function()? medium,
    T Function()? expanded,
    T Function()? large,
    T Function()? extraLarge,
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
