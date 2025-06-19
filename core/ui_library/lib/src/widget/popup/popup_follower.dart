import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Follower builder that wraps the child widget.
typedef PopupFollowerBuilder = Widget Function(BuildContext context, Widget? child);

/// Handles for follower widgets.
abstract interface class PopupFollowerController {
  /// Dismisses the popup.
  void dismiss();
}

/// {@template popup_follower}
/// A widget that adds additional functionality to the child widget.
///
/// It listens for the escape key and dismisses the popup when pressed.
/// It also listens for the tap outside the child widget and dismisses the popup.
/// {@endtemplate}
class PopupFollower extends StatefulWidget {
  const PopupFollower({
    required this.child,
    this.onDismiss,
    this.tapRegionGroupId,
    this.focusScopeNode,
    this.skipTraversal,
    this.consumeOutsideTaps = false,
    this.dismissOnResize = false,
    this.dismissOnScroll = true,
    this.constraints = const BoxConstraints(),
    this.autofocus = true,
    super.key,
  });

  /// The child widget that is wrapped.
  final Widget child;

  /// The callback that is called when the popup is dismissed.
  ///
  /// If this callback is not provided, the popup will not be dismissible.
  final VoidCallback? onDismiss;

  /// Follower constraints, if any.
  final BoxConstraints constraints;

  /// The group id of the [TapRegion].
  ///
  /// Refers to the [TapRegion.groupId].
  final Object? tapRegionGroupId;

  /// Whether to consume the outside taps.
  ///
  /// Refers to the [TapRegion.consumeOutsideTaps].
  final bool consumeOutsideTaps;

  /// Whether to dismiss the popup when the window is resized.
  final bool dismissOnResize;

  /// Whether to dismiss the popup when the scroll occurs.
  final bool dismissOnScroll;

  /// Whether the focus should be set to the child widget.
  final bool autofocus;

  /// The focus scope node.
  final FocusScopeNode? focusScopeNode;

  /// Whether to skip the focus traversal.
  final bool? skipTraversal;

  @override
  State<PopupFollower> createState() => _PopupFollowerState();
}

class _PopupFollowerState extends State<PopupFollower>
    with WidgetsBindingObserver
    implements PopupFollowerController {
  _FollowerScope? _parent;
  ScrollPosition? _scrollPosition;

  /// Whether the current widget is the root widget.
  bool get isRoot => _parent == null;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeDependencies() {
    _scrollPosition?.removeListener(_scrollableListener);
    _scrollPosition = Scrollable.maybeOf(context)?.position?..addListener(_scrollableListener);
    _parent = _FollowerScope.maybeOf(context, listen: true);
    super.didChangeDependencies();
  }

  @override
  void didChangeMetrics() {
    if (widget.dismissOnResize) {
      widget.onDismiss?.call();
    }
    super.didChangeMetrics();
  }

  void _scrollableListener() {
    if (widget.onDismiss != null && widget.dismissOnScroll && isRoot) {
      widget.onDismiss?.call();
    }
  }

  @override
  void dismiss() {
    if (widget.onDismiss != null && isRoot) {
      widget.onDismiss?.call();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _scrollPosition?.removeListener(_scrollableListener);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) => _FollowerScope(
    controller: this,
    parent: _parent,
    child: Actions(
      actions: {
        DismissIntent: CallbackAction<DismissIntent>(
          onInvoke: (intent) => widget.onDismiss?.call(),
        ),
      },
      child: Shortcuts(
        debugLabel: 'PopupFollower',
        shortcuts: {LogicalKeySet(LogicalKeyboardKey.escape): const DismissIntent()},
        child: Semantics(
          container: true,
          explicitChildNodes: true,
          child: FocusScope(
            debugLabel: 'PopupFollower',
            node: widget.focusScopeNode,
            skipTraversal: widget.skipTraversal,
            canRequestFocus: true,
            child: TapRegion(
              debugLabel: 'PopupFollower',
              groupId: widget.tapRegionGroupId,
              consumeOutsideTaps: widget.consumeOutsideTaps,
              onTapOutside: (_) => widget.onDismiss?.call(),
              child: ConstrainedBox(constraints: widget.constraints, child: widget.child),
            ),
          ),
        ),
      ),
    ),
  );
}

/// Follower Scope
class _FollowerScope extends InheritedWidget {
  /// Creates a new instance of [_FollowerScope].
  const _FollowerScope({required super.child, required this.controller, this.parent});

  /// The controller that is used to dismiss the popup.
  final PopupFollowerController controller;

  /// The parent [_FollowerScope] instance.
  final _FollowerScope? parent;

  /// Returns the closest [_FollowerScope] instance.
  static _FollowerScope? maybeOf(BuildContext context, {bool listen = false}) => listen
      ? context.dependOnInheritedWidgetOfExactType<_FollowerScope>()
      : context.getElementForInheritedWidgetOfExactType<_FollowerScope>()?.widget
            as _FollowerScope?;

  @override
  bool updateShouldNotify(_FollowerScope oldWidget) => false;
}
