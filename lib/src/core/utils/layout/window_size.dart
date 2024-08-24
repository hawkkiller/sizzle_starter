import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sizzle_starter/src/core/utils/extensions/context_extension.dart';

/// A breakpoint that is used to determine the layout of the application.
///
/// It follows the Material Design guidelines for breakpoints.
///
/// See more:
/// - https://m3.material.io/foundations/layout/applying-layout
sealed class WindowSize extends Size {
  WindowSize({
    required this.min,
    required this.max,
    required Size viewportSize,
  })  : assert(min < max, 'min must be less than max'),
        assert(
          viewportSize.width >= min && viewportSize.width <= max,
          'viewportSize must be between min and max',
        ),
        super.copy(viewportSize);

  factory WindowSize.fromSize(Size size) {
    if (size.width < 600) {
      return WindowSizeCompact(viewportSize: size);
    } else if (size.width < 840) {
      return WindowSizeMedium(viewportSize: size);
    } else if (size.width < 1200) {
      return WindowSizeExpanded(viewportSize: size);
    } else if (size.width < 1600) {
      return WindowSizeLarge(viewportSize: size);
    } else {
      return WindowSizeExtraLarge(viewportSize: size);
    }
  }

  /// The minimum width of the viewport
  final double min;

  /// The maximum width of the viewport
  final double max;
}

/// Compact window size.
class WindowSizeCompact extends WindowSize {
  /// Creates a [WindowSizeCompact] with the given [viewportSize].
  WindowSizeCompact({
    required super.viewportSize,
  }) : super(min: 0, max: 600);
}

/// Medium window size.
class WindowSizeMedium extends WindowSize {
  /// Creates a [WindowSizeMedium] with the given [viewportSize].
  WindowSizeMedium({
    required super.viewportSize,
  }) : super(min: 600, max: 840);
}

/// Expanded window size.
class WindowSizeExpanded extends WindowSize {
  /// Creates a [WindowSizeExpanded] with the given [viewportSize].
  WindowSizeExpanded({
    required super.viewportSize,
  }) : super(min: 840, max: 1200);
}

/// Large window size.
class WindowSizeLarge extends WindowSize {
  /// Creates a [WindowSizeLarge] with the given [viewportSize].
  WindowSizeLarge({
    required super.viewportSize,
  }) : super(min: 1200, max: 1600);
}

/// Extra large window size.
class WindowSizeExtraLarge extends WindowSize {
  /// Creates a [WindowSizeExtraLarge] with the given [viewportSize].
  WindowSizeExtraLarge({
    required super.viewportSize,
  }) : super(min: 1600, max: double.infinity);
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
