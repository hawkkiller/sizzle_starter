import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// A breakpoint that is used to determine the layout of the application.
///
/// It follows the Material Design guidelines for breakpoints.
///
/// See more:
/// - https://m3.material.io/foundations/layout/applying-layout
enum WindowSize {
  /// Layouts for compact window size classes
  /// are for screen widths smaller than 600dp.
  compact._(0, 600),

  /// Layouts for medium window size classes
  /// are for screen widths from 600dp to 839dp.
  medium._(600, 839),

  /// Layouts for expanded window size classes
  /// are for screen widths 840dp to 1199dp.
  expanded._(840, 1199),

  /// Layouts for large window size classes
  /// are for screen widths from 1200dp to 1599dp.
  large._(1200, 1599),

  /// Layouts for extra-large window size classes
  /// are for screen widths of 1600dp and larger.
  extraLarge._(1600, double.infinity);

  /// The minimum width of the breakpoint.
  final double min;

  /// The maximum width of the breakpoint.
  final double max;

  /// Returns the [WindowSize] for the given width.
  static WindowSize fromWidth(double width) {
    if (width < 0) {
      throw ArgumentError.value(width, 'width', 'Width cannot be negative');
    }

    if (compact.isInRange(width)) {
      return compact;
    } else if (medium.isInRange(width)) {
      return medium;
    } else if (expanded.isInRange(width)) {
      return expanded;
    } else if (large.isInRange(width)) {
      return large;
    }

    return extraLarge;
  }

  /// Returns whether the given width is in the range of the breakpoint.
  bool isInRange(double width) => width >= min && width <= max;

  /// Returns whether the given width isless than
  /// the minimum width of the breakpoint.
  bool operator <(WindowSize other) => min < other.min;

  /// Returns whether the given width is greater than
  /// the maximum width of the breakpoint.
  bool operator >(WindowSize other) => min > other.min;

  /// Returns whether the given width is less than
  /// or equal to the maximum width of the breakpoint.
  bool operator <=(WindowSize other) => min <= other.min;

  /// Returns whether the given width is greater than
  /// or equal to the minimum width of the breakpoint.
  bool operator >=(WindowSize other) => min >= other.min;

  /// If the breakpoint is compact.
  bool get isCompact => this == WindowSize.compact;

  /// If the breakpoint is compact or larger.
  bool get isCompactUp => this >= WindowSize.compact;

  /// If the breakpoint is medium.
  bool get isMedium => this == WindowSize.medium;

  /// If the breakpoint is medium or larger.
  bool get isMediumUp => this >= WindowSize.medium;

  /// If the breakpoint is expanded.
  bool get isExpanded => this == WindowSize.expanded;

  /// If the breakpoint is expanded or larger.
  bool get isExpandedUp => this >= WindowSize.expanded;

  /// If the breakpoint is large.
  bool get isLarge => this == WindowSize.large;

  /// If the breakpoint is large or larger.
  bool get isLargeUp => this >= WindowSize.large;

  /// If the breakpoint is extra-large.
  bool get isExtraLarge => this == WindowSize.extraLarge;

  /// If the breakpoint is extra-large or larger.
  bool get isExtraLargeUp => this >= WindowSize.extraLarge;

  const WindowSize._(this.min, this.max);
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
  static WindowSize of(BuildContext context, {bool listen = true}) {
    final inherited = listen
        ? context.dependOnInheritedWidgetOfExactType<_InheritedWindowSize>()
        : context.findAncestorWidgetOfExactType<_InheritedWindowSize>();

    return inherited?.windowSize ??
        (throw FlutterError('WindowSizeScope was not found in the widget tree'));
  }

  @override
  State<WindowSizeScope> createState() => _WindowSizeScopeState();
}

class _WindowSizeScopeState extends State<WindowSizeScope> with WidgetsBindingObserver {
  late WindowSize _windowSize;

  Size _getScreenSize() {
    final view = PlatformDispatcher.instance.views.first;
    return view.physicalSize / view.devicePixelRatio;
  }

  @override
  void initState() {
    _windowSize = WindowSize.fromWidth(_getScreenSize().width);
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void didChangeMetrics() {
    final windowSize = WindowSize.fromWidth(_getScreenSize().width);

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
