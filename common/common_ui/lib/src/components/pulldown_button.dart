import 'dart:async';

import 'package:common_ui/common_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A button that shows anchored overlay content when pressed.
///
/// The button defaults to an icon-only overflow affordance and animates the
/// pulldown content with a fade-and-scale transition.
class UiPulldownButton extends StatefulWidget {
  /// Creates a pulldown button.
  const UiPulldownButton({
    required this.content,
    this.enabled = true,
    this.size = UiButtonSize.standard,
    this.width = UiButtonWidth.hug,
    this.offset,
    this.targetAnchor = Alignment.topRight,
    this.followerAnchor = Alignment.topRight,
    this.icon,
    this.label,
    this.iconOnly = true,
    super.key,
  });

  /// The pulldown content shown in the overlay.
  final Widget content;

  /// Whether the button can be pressed.
  final bool enabled;

  /// The size of the trigger button.
  final UiButtonSize size;

  /// The width behavior of the trigger button.
  final UiButtonWidth width;

  /// The offset applied between the trigger and the pulldown content.
  final Offset? offset;

  /// The anchor on the trigger that the pulldown attaches to.
  final Alignment targetAnchor;

  /// The anchor on the pulldown content aligned to [targetAnchor].
  final Alignment followerAnchor;

  /// The accessible button label.
  final String? label;

  /// Whether the trigger hides the label visually.
  final bool iconOnly;

  /// Optional trigger icon.
  final Widget? icon;

  @override
  State<UiPulldownButton> createState() => _UiPulldownButtonState();
}

class _UiPulldownButtonState extends State<UiPulldownButton> with SingleTickerProviderStateMixin {
  final Object _tapRegionGroupId = Object();

  late final _flyoutFocusNode = FocusNode(debugLabel: 'Pulldown Flyout');
  late final AnimationController _animationController;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _opacityAnimation;
  late Animation<Color?> _backgroundColorAnimation;

  bool _isOpen = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 125),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.93, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    _opacityAnimation = CurvedAnimation(parent: _animationController, curve: Curves.easeOut);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final theme = UiTheme.of(context);
    _backgroundColorAnimation = ColorTween(
      begin: Colors.transparent,
      end: theme.color.scrim.withValues(alpha: .2),
    ).animate(_opacityAnimation);
  }

  @override
  void didUpdateWidget(covariant UiPulldownButton oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.enabled && !widget.enabled) {
      _hide();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _flyoutFocusNode.dispose();
    super.dispose();
  }

  void _show() {
    if (_isOpen || !widget.enabled) return;

    setState(() => _isOpen = true);
    unawaited(_animationController.forward(from: 0));
    _flyoutFocusNode.requestFocus();
  }

  void _hide() {
    if (!_isOpen && _animationController.status == AnimationStatus.dismissed) {
      return;
    }

    unawaited(_hideFlyout());
  }

  Future<void> _hideFlyout() async {
    await _animationController.reverse();

    if (!mounted || !_isOpen) return;

    setState(() => _isOpen = false);
  }

  @override
  Widget build(BuildContext context) {
    // TODO(mlazebny): translations
    final buttonLabel = widget.label ?? 'More actions';
    final spacing = UiTheme.of(context).spacing;

    return TapRegion(
      groupId: _tapRegionGroupId,
      onTapOutside: (_) => _hide(),
      child: UiFlyout(
        isOpen: _isOpen,
        onHideRequested: _hide,
        anchor: UiFlyoutAnchor(
          offset: widget.offset ?? Offset(spacing.s4, -spacing.s2),
          anchorAlignment: widget.targetAnchor,
          flyoutAlignment: widget.followerAnchor,
        ),
        overlayBuilder: (context, flyout) {
          return AnimatedBuilder(
            animation: _backgroundColorAnimation,
            builder: (context, child) {
              return Stack(
                fit: StackFit.expand,
                children: [
                  ColoredBox(color: _backgroundColorAnimation.value!),
                  child!,
                ],
              );
            },
            child: flyout,
          );
        },
        flyoutBuilder: (context) {
          return TapRegion(
            groupId: _tapRegionGroupId,
            child: FocusTraversalGroup(
              child: Shortcuts(
                shortcuts: const {
                  SingleActivator(LogicalKeyboardKey.escape): DismissIntent(),
                },
                child: Actions(
                  actions: {
                    DismissIntent: CallbackAction<DismissIntent>(
                      onInvoke: (intent) {
                        _hide();
                        return null;
                      },
                    ),
                  },
                  child: FocusScope(
                    child: Focus(
                      skipTraversal: true,
                      focusNode: _flyoutFocusNode,
                      child: Semantics(
                        container: true,
                        explicitChildNodes: true,
                        child: ScaleTransition(
                          alignment: widget.followerAnchor,
                          scale: _scaleAnimation,
                          child: FadeTransition(opacity: _opacityAnimation, child: widget.content),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
        child: Semantics(
          expanded: _isOpen,
          child: UiButton(
            label: buttonLabel,
            style: UiButtonStyle.outline,
            iconOnly: widget.iconOnly,
            icon: widget.icon ?? const Icon(Icons.more_horiz),
            size: widget.size,
            width: widget.width,
            enabled: widget.enabled,
            onPressed: _show,
          ),
        ),
      ),
    );
  }
}
