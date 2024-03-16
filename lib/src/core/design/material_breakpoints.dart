import 'package:flutter/widgets.dart';

/// A breakpoint that is used to determine the layout of the application.
///
/// It follows the Material Design guidelines for breakpoints.
///
/// See more:
/// - https://m3.material.io/foundations/layout/applying-layout
enum MaterialBreakpoint {
  /// Layouts for compact window size classes
  /// are for screen widths smaller than 600dp.
  compact._(double.negativeInfinity, 600),

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
  extraLarge._(1600, double.infinity),
  ;

  /// The minimum width of the breakpoint.
  final double min;

  /// The maximum width of the breakpoint.
  final double max;

  /// Returns whether the given width is in the range of the breakpoint.
  bool isInRange(double width) => width >= min && width <= max;

  /// Returns whether the given width isless than
  /// the minimum width of the breakpoint.
  bool operator <(MaterialBreakpoint other) => max < other.min;

  /// Returns whether the given width is greater than
  /// the maximum width of the breakpoint.
  bool operator >(MaterialBreakpoint other) => min > other.max;

  /// Returns whether the given width is less than
  /// or equal to the maximum width of the breakpoint.
  bool operator <=(MaterialBreakpoint other) => max <= other.max;

  /// Returns whether the given width is greater than
  /// or equal to the minimum width of the breakpoint.
  bool operator >=(MaterialBreakpoint other) => min >= other.min;

  /// If the breakpoint is compact.
  bool get isCompact => this == MaterialBreakpoint.compact;

  /// If the breakpoint is medium.
  bool get isMedium => this == MaterialBreakpoint.medium;

  /// If the breakpoint is expanded.
  bool get isExpanded => this == MaterialBreakpoint.expanded;

  /// If the breakpoint is large.
  bool get isLarge => this == MaterialBreakpoint.large;

  /// If the breakpoint is extra-large.
  bool get isExtraLarge => this == MaterialBreakpoint.extraLarge;

  const MaterialBreakpoint._(this.min, this.max);
}

/// A set of extensions for [MaterialBreakpoint] on [BoxConstraints].
extension MaterialBreakpointsConstrainsX on BoxConstraints {
  /// Returns the [MaterialBreakpoint] for the given constraints.
  MaterialBreakpoint get materialBreakpoint {
    if (MaterialBreakpoint.compact.isInRange(maxWidth)) {
      return MaterialBreakpoint.compact;
    } else if (MaterialBreakpoint.medium.isInRange(maxWidth)) {
      return MaterialBreakpoint.medium;
    } else if (MaterialBreakpoint.expanded.isInRange(maxWidth)) {
      return MaterialBreakpoint.expanded;
    } else if (MaterialBreakpoint.large.isInRange(maxWidth)) {
      return MaterialBreakpoint.large;
    }

    return MaterialBreakpoint.extraLarge;
  }
}
