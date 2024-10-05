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
  const WindowSize(super.width, super.height);

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
  bool get isCompact => maybeMap(compactFn: () => true, orElse: () => false);

  /// Returns `true` if the viewport width is within the range of the compact breakpoint or bigger.
  bool get isCompactOrUp => maybeMap(orElse: () => true);

  /// Returns `true` if the viewport width is within the range of the medium breakpoint.
  bool get isMedium => maybeMap(mediumFn: () => true, orElse: () => false);

  /// Returns `true` if the viewport width is within the range of the medium breakpoint or bigger.
  bool get isMediumOrUp => maybeMap(
        mediumFn: () => true,
        expandedFn: () => true,
        largeFn: () => true,
        extraLargeFn: () => true,
        orElse: () => false,
      );

  /// Returns `true` if the viewport width is within the range of the expanded breakpoint.
  bool get isExpanded => maybeMap(expandedFn: () => true, orElse: () => false);

  /// Returns `true` if the viewport width is within the range of the expanded breakpoint or bigger.
  bool get isExpandedOrUp => maybeMap(
        expandedFn: () => true,
        largeFn: () => true,
        extraLargeFn: () => true,
        orElse: () => false,
      );

  /// Returns `true` if the viewport width is within the range of the large breakpoint.
  bool get isLarge => maybeMap(largeFn: () => true, orElse: () => false);

  /// Returns `true` if the viewport width is within the range of the large breakpoint or bigger.
  bool get isLargeOrUp => maybeMap(
        largeFn: () => true,
        extraLargeFn: () => true,
        orElse: () => false,
      );

  /// Returns `true` if the viewport width is within the range of the extra large breakpoint.
  bool get isExtraLarge => maybeMap(
        extraLargeFn: () => true,
        orElse: () => false,
      );

  /// Return value based on the current breakpoint.
  T map<T>({
    required T Function() compactFn,
    required T Function() mediumFn,
    required T Function() expandedFn,
    required T Function() largeFn,
    required T Function() extraLargeFn,
  }) =>
      switch (width) {
        >= WindowSize.extraLarge => extraLargeFn(),
        >= WindowSize.large => largeFn(),
        >= WindowSize.expanded => expandedFn(),
        >= WindowSize.medium => mediumFn(),
        _ => compactFn(),
      };

  /// Return value based on the current breakpoint.
  T maybeMap<T>({
    required T Function() orElse,
    T Function()? compactFn,
    T Function()? mediumFn,
    T Function()? expandedFn,
    T Function()? largeFn,
    T Function()? extraLargeFn,
  }) =>
      map(
        compactFn: compactFn ?? orElse,
        mediumFn: mediumFn ?? orElse,
        expandedFn: expandedFn ?? orElse,
        largeFn: largeFn ?? orElse,
        extraLargeFn: extraLargeFn ?? orElse,
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
  const WindowSizeScope({required this.child, super.key});

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
