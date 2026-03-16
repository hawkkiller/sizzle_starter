import 'dart:async';

import 'package:flutter/material.dart';

const _pressTransitionDuration = Duration(milliseconds: 150);
const _pressTransitionReleaseDelay = Duration(milliseconds: 50);

/// Builds the widget tree for a [PressTransition].
typedef PressTransitionBuilder =
    Widget Function(
      BuildContext context,
      double pressProgress,
      Widget? child,
    );

/// Notification sent when a [PressTransition] handles a press.
/// Used to prevent ancestor [PressTransition]s from animating.
class _PressTransitionNotification extends Notification {
  const _PressTransitionNotification();
}

/// A widget that exposes press progress to build custom press feedback.
///
/// When nested, only the innermost [PressTransition] will animate,
/// preventing unwanted visual effects on parent buttons.
class PressTransition extends StatefulWidget {
  /// Creates a press transition.
  const PressTransition({
    required this.builder,
    this.child,
    this.enabled = true,
    this.onTap,
    this.duration = _pressTransitionDuration,
    this.releaseDelay = _pressTransitionReleaseDelay,
    this.curve = Curves.easeInOut,
    super.key,
  });

  /// Builds the transition using the current press progress.
  final PressTransitionBuilder builder;

  /// Optional child passed through to [builder].
  final Widget? child;

  /// Whether the press transition responds to pointer interaction.
  final bool enabled;

  /// Called when the press is recognized as a tap.
  final VoidCallback? onTap;

  /// The duration of the press-in and release animation.
  final Duration duration;

  /// The minimum delay before the press state releases.
  final Duration releaseDelay;

  /// The curve applied to the press progress.
  final Curve curve;

  @override
  State<PressTransition> createState() => _PressTransitionState();
}

class _PressTransitionState extends State<PressTransition> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  bool _childHandledPress = false;
  Timer? _releaseTimer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
  }

  @override
  void didUpdateWidget(covariant PressTransition oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.duration != widget.duration) {
      _controller.duration = widget.duration;
    }
  }

  @override
  void dispose() {
    _releaseTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _handlePressStart() {
    if (!widget.enabled) {
      return;
    }

    _releaseTimer?.cancel();

    const _PressTransitionNotification().dispatch(context);

    Future.microtask(() {
      if (!_childHandledPress && mounted) {
        _controller.forward();
      }

      _childHandledPress = false;
    });
  }

  void _handlePressEnd() {
    if (!widget.enabled) {
      return;
    }

    _scheduleRelease();
  }

  void _handlePressCancel() {
    if (!widget.enabled) {
      return;
    }

    _scheduleRelease();
  }

  void _scheduleRelease() {
    _releaseTimer?.cancel();
    _releaseTimer = Timer(widget.releaseDelay, () {
      if (!mounted) {
        return;
      }

      _controller.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<_PressTransitionNotification>(
      onNotification: (notification) {
        _childHandledPress = true;
        return false;
      },
      child: Listener(
        behavior: HitTestBehavior.translucent,
        onPointerDown: (_) => _handlePressStart(),
        onPointerUp: (_) => _handlePressEnd(),
        onPointerCancel: (_) => _handlePressCancel(),
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedBuilder(
            animation: _controller,
            child: widget.child,
            builder: (context, child) {
              return widget.builder(
                context,
                widget.curve.transform(_controller.value),
                child,
              );
            },
          ),
        ),
      ),
    );
  }
}
