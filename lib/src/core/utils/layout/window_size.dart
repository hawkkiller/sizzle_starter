import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

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

  /// Returns whether the given width is in the range of the breakpoint.
  bool isInRange(double width) => width >= min && width <= max;

  /// Returns whether the given width isless than
  /// the minimum width of the breakpoint.
  bool operator <(WindowSize other) => max < other.min;

  /// Returns whether the given width is greater than
  /// the maximum width of the breakpoint.
  bool operator >(WindowSize other) => min > other.max;

  /// Returns whether the given width is less than
  /// or equal to the maximum width of the breakpoint.
  bool operator <=(WindowSize other) => max <= other.max;

  /// Returns whether the given width is greater than
  /// or equal to the minimum width of the breakpoint.
  bool operator >=(WindowSize other) => min >= other.min;

  /// If the breakpoint is compact.
  bool get isCompact => this == WindowSize.compact;

  /// If the breakpoint is medium.
  bool get isMedium => this == WindowSize.medium;

  /// If the breakpoint is expanded.
  bool get isExpanded => this == WindowSize.expanded;

  /// If the breakpoint is large.
  bool get isLarge => this == WindowSize.large;

  /// If the breakpoint is extra-large.
  bool get isExtraLarge => this == WindowSize.extraLarge;

  const WindowSize._(this.min, this.max);
}

/// A set of extensions for [WindowSize] on [BoxConstraints].
extension WindowSizeConstrainsExtension on BoxConstraints {
  /// Returns the [WindowSize] for the given constraints.
  WindowSize get materialBreakpoint {
    final side = biggest.width;

    if (WindowSize.compact.isInRange(side)) {
      return WindowSize.compact;
    } else if (WindowSize.medium.isInRange(side)) {
      return WindowSize.medium;
    } else if (WindowSize.expanded.isInRange(side)) {
      return WindowSize.expanded;
    } else if (WindowSize.large.isInRange(side)) {
      return WindowSize.large;
    }

    return WindowSize.extraLarge;
  }
}
