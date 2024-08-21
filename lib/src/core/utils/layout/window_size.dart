import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sizzle_starter/src/core/utils/extensions/context_extension.dart';

/// A breakpoint that is used to determine the layout of the application.
///
/// It follows the Material Design guidelines for breakpoints.
///
/// See more:
/// - https://m3.material.io/foundations/layout/applying-layout
extension type WindowSize(Size size) implements Size {
  /// Compact breakpoint.
  static const compactMin = 0;

  /// Compact breakpoint.
  static const compactMax = 599;

  /// Medium breakpoint.
  static const mediumMin = 600;

  /// Medium breakpoint.
  static const mediumMax = 839;

  /// Expanded breakpoint.
  static const expandedMin = 840;

  /// Expanded breakpoint.
  static const expandedMax = 1199;

  /// Large breakpoint.
  static const largeMin = 1200;

  /// Large breakpoint.
  static const largeMax = 1599;

  /// Extra large breakpoint.
  static const extraLargeMin = 1600;

  /// Extra large breakpoint.
  static const extraLargeMax = double.infinity;

  /// Returns true if the window size is within the compact range.
  bool get isCompact => compactMin <= width && width < compactMax;

  /// Returns true if the window size is within or bigger than the compact range.
  bool get isCompactUp => compactMin >= width;

  /// Returns true if the window size is within the medium range.
  bool get isMedium => mediumMin <= width && width < mediumMax;

  /// Returns true if the window size is within or bigger than the medium range.
  bool get isMediumUp => mediumMin >= width;

  /// Returns true if the window size is within the expanded range.
  bool get isExpanded => expandedMin <= width && width < expandedMax;

  /// Returns true if the window size is within or bigger than the expanded range.
  bool get isExpandedUp => expandedMin >= width;

  /// Returns true if the window size is within the large range.
  bool get isLarge => largeMin <= width && width < largeMax;

  /// Returns true if the window size is within or bigger than the large range.
  bool get isLargeUp => largeMin >= width;

  /// Returns true if the window size is within the extra large range.
  bool get isExtraLarge => extraLargeMin <= width && width < extraLargeMax;

  /// Returns true if the window size is within or bigger than the extra large range.
  bool get isExtraLargeUp => extraLargeMax >= width;
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
    return WindowSize(view.physicalSize / view.devicePixelRatio);
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
