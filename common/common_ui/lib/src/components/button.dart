// ignore_for_file: no-equal-switch-expression-cases

import 'package:common_ui/common_ui.dart';
import 'package:flutter/material.dart';

/// Notification sent when a [PressScaleTransition] handles a press.
/// Used to prevent ancestor [PressScaleTransition]s from animating.
class _PressScaleNotification extends Notification {
  const _PressScaleNotification();
}

/// A widget that adds a subtle scale down effect when pressed.
///
/// When nested, only the innermost [PressScaleTransition] will animate,
/// preventing unwanted visual effects on parent buttons.
class PressScaleTransition extends StatefulWidget {
  const PressScaleTransition({required this.child, this.enabled = true, super.key});

  final bool enabled;
  final Widget child;

  @override
  State<PressScaleTransition> createState() => _PressScaleTransitionState();
}

class _PressScaleTransitionState extends State<PressScaleTransition>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;
  bool _childHandledPress = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.97).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    if (!widget.enabled) return;

    // Notify ancestors that this press is being handled
    const _PressScaleNotification().dispatch(context);

    // Use microtask to check if a child notification arrived first
    Future.microtask(() {
      if (!_childHandledPress && mounted) {
        _controller.forward();
      }
      // Reset flag for next interaction
      _childHandledPress = false;
    });
  }

  Future<void> _handleTapUp(TapUpDetails details) async {
    if (!widget.enabled) return;
    await Future<void>.delayed(const Duration(milliseconds: 50));

    if (!mounted) return;
    await _controller.reverse();
  }

  Future<void> _handleTapCancel() async {
    if (!widget.enabled) return;
    await Future<void>.delayed(const Duration(milliseconds: 50));

    if (!mounted) return;
    await _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<_PressScaleNotification>(
      onNotification: (notification) {
        // A descendant PressScaleTransition is handling the press
        _childHandledPress = true;
        return false; // Continue propagating to further ancestors
      },
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTapDown: _handleTapDown,
        onTapUp: _handleTapUp,
        onTapCancel: _handleTapCancel,
        child: ScaleTransition(scale: _scaleAnimation, child: widget.child),
      ),
    );
  }
}

/// The visual style of the button (affects shape/background).
enum UiButtonStyle { primary, secondary, outline, ghost }

/// The semantic role of the button (affects color).
enum UiButtonRole { normal, destructive }

enum UiButtonSize {
  standard,
  medium,
  large;

  double get height => switch (this) {
    UiButtonSize.standard => 36,
    UiButtonSize.medium => 44,
    UiButtonSize.large => 52,
  };
}

enum UiButtonWidth {
  hug,
  fill;

  double? get value => switch (this) {
    UiButtonWidth.hug => null,
    UiButtonWidth.fill => double.infinity,
  };
}

/// A unified button widget that supports multiple styles and roles.
///
/// The [label] is always required for accessibility — even for icon-only
/// buttons, the label is used for screen readers and tooltips.
class UiButton extends StatelessWidget {
  const UiButton({
    required this.label,
    required this.onPressed,
    this.style = UiButtonStyle.primary,
    this.role = UiButtonRole.normal,
    this.size = UiButtonSize.standard,
    this.width = UiButtonWidth.hug,
    this.enabled = true,
    this.isLoading = false,
    this.alignment = Alignment.center,
    this.trailing,
    this.icon,
    this.emphasized = false,
    this.iconOnly = false,
    super.key,
  });

  const UiButton.iconOnly({
    required this.label,
    required this.icon,
    required this.onPressed,
    this.style = UiButtonStyle.primary,
    this.role = UiButtonRole.normal,
    this.size = UiButtonSize.standard,
    this.width = UiButtonWidth.hug,
    this.enabled = true,
    this.isLoading = false,
    this.alignment = Alignment.center,
    super.key,
  }) : iconOnly = true,
       trailing = null,
       emphasized = false;

  /// The button label. Always required for accessibility.
  /// When [iconOnly] is true, this is used for the tooltip and screen readers.
  final String label;

  /// Optional leading icon.
  final Widget? icon;

  /// When true, hides the label visually but keeps it for accessibility.
  final bool iconOnly;

  /// The visual style of the button.
  final UiButtonStyle style;

  /// The semantic role affecting the button's color.
  final UiButtonRole role;

  /// The size of the button.
  final UiButtonSize size;

  /// The width behavior of the button.
  final UiButtonWidth width;

  /// Whether the button is in a loading state.
  final bool isLoading;

  /// Whether the button is enabled.
  final bool enabled;

  /// Called when the button is pressed.
  final VoidCallback? onPressed;

  /// The alignment of the button's label.
  final Alignment alignment;

  /// Optional trailing widget.
  ///
  /// This has no effect when [iconOnly] is true.
  final Widget? trailing;

  /// Whether the button should be emphasized.
  final bool emphasized;

  bool get _enabled => enabled && onPressed != null && !isLoading;

  @override
  Widget build(BuildContext context) {
    final theme = UiTheme.of(context);
    final colors = _resolveColors(theme);

    var button = iconOnly ? _buildIconButton(theme, colors) : _buildLabelButton(theme, colors);

    if (iconOnly) {
      button = Tooltip(message: label, child: button);
    }

    return MergeSemantics(
      child: PressScaleTransition(enabled: _enabled, child: button),
    );
  }

  /// Resolves colors based on style and role combination.
  ({Color bg, Color fg, Color? border, Color overlay, Color shadow, double elevation})
  _resolveColors(UiTheme theme) {
    final c = theme.color;
    final o = theme.opacity;
    final e = theme.elevation;

    return switch ((style, role)) {
      // Primary
      (UiButtonStyle.primary, UiButtonRole.normal) => (
        bg: c.primary,
        fg: c.onPrimary,
        border: null,
        overlay: c.onPrimary.withValues(alpha: o.hover),
        shadow: c.primary.withValues(alpha: o.scrim),
        elevation: _enabled ? e.raised : e.none,
      ),
      (UiButtonStyle.primary, UiButtonRole.destructive) => (
        bg: c.error,
        fg: c.onError,
        border: null,
        overlay: c.onError.withValues(alpha: o.hover),
        shadow: c.error.withValues(alpha: o.scrim),
        elevation: _enabled ? e.raised : e.none,
      ),
      // Secondary
      (UiButtonStyle.secondary, UiButtonRole.normal) => (
        bg: c.surface,
        fg: c.onSurface,
        border: null,
        overlay: c.onSurface.withValues(alpha: o.hover),
        shadow: c.onSurface.withValues(alpha: o.scrim),
        elevation: e.none,
      ),
      (UiButtonStyle.secondary, UiButtonRole.destructive) => (
        bg: c.surface,
        fg: c.error,
        border: null,
        overlay: c.error.withValues(alpha: o.hover),
        shadow: c.onSurface.withValues(alpha: o.scrim),
        elevation: e.none,
      ),
      // Outline
      (UiButtonStyle.outline, UiButtonRole.normal) => (
        bg: Colors.transparent,
        fg: c.onSurface,
        border: c.outline,
        overlay: c.onSurface.withValues(alpha: o.hover),
        shadow: Colors.transparent,
        elevation: e.none,
      ),
      (UiButtonStyle.outline, UiButtonRole.destructive) => (
        bg: Colors.transparent,
        fg: c.error,
        border: c.error,
        overlay: c.error.withValues(alpha: o.hover),
        shadow: Colors.transparent,
        elevation: e.none,
      ),
      // Ghost
      (UiButtonStyle.ghost, UiButtonRole.normal) => (
        bg: Colors.transparent,
        fg: c.onSurface,
        border: null,
        overlay: c.onSurface.withValues(alpha: o.hover),
        shadow: Colors.transparent,
        elevation: e.none,
      ),
      (UiButtonStyle.ghost, UiButtonRole.destructive) => (
        bg: Colors.transparent,
        fg: c.error,
        border: null,
        overlay: c.error.withValues(alpha: o.hover),
        shadow: Colors.transparent,
        elevation: e.none,
      ),
    };
  }

  Widget _buildLabelButton(
    UiTheme theme,
    ({Color bg, Color fg, Color? border, Color overlay, Color shadow, double elevation}) colors,
  ) {
    final shape = RoundedSuperellipseBorder(
      borderRadius: BorderRadius.circular(theme.radius.component),
      side: colors.border != null
          ? BorderSide(color: colors.border!, width: theme.borderWidth.subtle)
          : BorderSide.none,
    );

    final buttonStyle = FilledButton.styleFrom(
      elevation: colors.elevation,
      shadowColor: colors.shadow,
      splashFactory: NoSplash.splashFactory,
      backgroundColor: colors.bg,
      foregroundColor: colors.fg,
      overlayColor: colors.overlay,
      shape: shape,
      alignment: alignment,
      tapTargetSize: MaterialTapTargetSize.padded,
      textStyle: theme.typography.labelLarge.copyWith(
        fontWeight: emphasized ? FontWeight.w600 : FontWeight.w500,
      ),
    );

    return ConstrainedBox(
      constraints: BoxConstraints(
        minHeight: size.height,
        minWidth: width.value ?? 0,
      ),
      child: FilledButton.icon(
        onPressed: _enabled ? onPressed : null,
        icon: isLoading ? null : icon,
        style: buttonStyle,
        label: Stack(
          alignment: Alignment.center,
          children: [
            // Keep label for sizing, hide when loading
            Visibility(
              visible: !isLoading,
              maintainSize: true,
              maintainAnimation: true,
              maintainState: true,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                spacing: theme.spacing.s4,
                children: [Text(label), if (trailing != null) trailing!],
              ),
            ),
            // Show loader centered on top
            if (isLoading) const UiLoader(size: UiLoaderSize.small),
          ],
        ),
      ),
    );
  }

  Widget _buildIconButton(
    UiTheme theme,
    ({Color bg, Color fg, Color? border, Color overlay, Color shadow, double elevation}) colors,
  ) {
    final iconSize = switch (size) {
      UiButtonSize.standard => const Size(40, 40),
      UiButtonSize.medium => const Size(56, 56),
      UiButtonSize.large => const Size(64, 64),
    };

    return IconButton(
      onPressed: _enabled ? onPressed : null,
      icon: isLoading
          ? UiLoader(size: UiLoaderSize.small, color: theme.color.onSurfaceMuted)
          : (icon ?? const SizedBox.shrink()),
      style: IconButton.styleFrom(
        splashFactory: NoSplash.splashFactory,
        fixedSize: iconSize,
        foregroundColor: colors.fg,
        backgroundColor: colors.bg,
        overlayColor: colors.overlay,
        shadowColor: colors.shadow,
        elevation: colors.elevation,
        alignment: alignment,
        shape: RoundedSuperellipseBorder(
          borderRadius: BorderRadius.circular(theme.radius.component),
          side: colors.border != null
              ? BorderSide(color: colors.border!, width: theme.borderWidth.subtle)
              : BorderSide.none,
        ),
      ),
    );
  }
}
