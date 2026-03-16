// ignore_for_file: no-equal-switch-expression-cases

import 'dart:ui' show lerpDouble;

import 'package:common_ui/common_ui.dart';
import 'package:flutter/material.dart';

/// Optional color overrides for a [UiButton].
@immutable
class UiButtonColors {
  /// Creates button color overrides.
  const UiButtonColors({
    this.background,
    this.disabledBackground,
    this.foreground,
    this.disabledForeground,
    this.border,
    this.overlay,
    this.shadow,
    this.elevation,
  });

  /// The background color.
  final Color? background;

  /// The background color while disabled.
  final Color? disabledBackground;

  /// The foreground color.
  final Color? foreground;

  /// The foreground color while disabled.
  final Color? disabledForeground;

  /// The optional border color.
  final Color? border;

  /// The pressed and hovered overlay color.
  final Color? overlay;

  /// The shadow color.
  final Color? shadow;

  /// The elevation.
  final double? elevation;
}

/// The visual style of the button (affects shape/background).
enum UiButtonStyle { primary, secondary, outline, ghost }

/// The semantic role of the button (affects color).
enum UiButtonRole { normal, accent, destructive }

enum UiButtonSize {
  standard,
  medium,
  large
  ;

  double get height => switch (this) {
    UiButtonSize.standard => 36,
    UiButtonSize.medium => 44,
    UiButtonSize.large => 52,
  };

  /// The loader size that matches this button size.
  UiLoaderSize get loaderSize => switch (this) {
    UiButtonSize.standard => UiLoaderSize.small,
    UiButtonSize.medium => UiLoaderSize.small,
    UiButtonSize.large => UiLoaderSize.medium,
  };
}

enum UiButtonWidth {
  hug,
  fill
  ;

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
    this.colors,
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
    this.colors,
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

  /// Optional color overrides applied after the built-in style resolution.
  final UiButtonColors? colors;

  bool get _enabled => enabled && onPressed != null && !isLoading;

  @override
  Widget build(BuildContext context) {
    final theme = UiTheme.of(context);
    final colors = _applyColorOverrides(_resolveColors(theme));

    var button = iconOnly ? _buildIconButton(theme, colors) : _buildLabelButton(theme, colors);

    if (iconOnly) {
      button = Tooltip(message: label, child: button);
    }

    return MergeSemantics(
      child: PressTransition(
        enabled: _enabled,
        child: button,
        builder: (context, pressProgress, child) {
          return Transform.scale(
            scale: lerpDouble(1, 0.97, pressProgress) ?? 1,
            child: child,
          );
        },
      ),
    );
  }

  /// Resolves colors based on style and role combination.
  ({
    Color bg,
    Color disabledBg,
    Color fg,
    Color disabledFg,
    Color? border,
    Color overlay,
    Color shadow,
    double elevation,
  })
  _resolveColors(UiTheme theme) {
    final c = theme.color;
    final o = theme.opacity;
    final e = theme.elevation;

    Color dim(Color color) => color.withValues(alpha: color.a * o.disabled);

    return switch ((style, role)) {
      // Primary
      (UiButtonStyle.primary, UiButtonRole.normal) => (
        bg: c.primary,
        disabledBg: dim(c.primary),
        fg: c.onPrimary,
        disabledFg: dim(c.onPrimary),
        border: null,
        overlay: c.onPrimary.withValues(alpha: o.hover),
        shadow: c.primary.withValues(alpha: o.scrim),
        elevation: _enabled ? e.raised : e.none,
      ),
      (UiButtonStyle.primary, UiButtonRole.accent) => (
        bg: c.primary,
        disabledBg: dim(c.primary),
        fg: c.onPrimary,
        disabledFg: dim(c.onPrimary),
        border: null,
        overlay: c.onPrimary.withValues(alpha: o.hover),
        shadow: c.primary.withValues(alpha: o.scrim),
        elevation: _enabled ? e.raised : e.none,
      ),
      (UiButtonStyle.primary, UiButtonRole.destructive) => (
        bg: c.error,
        disabledBg: dim(c.error),
        fg: c.onError,
        disabledFg: dim(c.onError),
        border: null,
        overlay: c.onError.withValues(alpha: o.hover),
        shadow: c.error.withValues(alpha: o.scrim),
        elevation: _enabled ? e.raised : e.none,
      ),
      // Secondary
      (UiButtonStyle.secondary, UiButtonRole.normal) => (
        bg: c.surfaceInteractive,
        disabledBg: dim(c.surfaceInteractive),
        fg: c.onSurface,
        disabledFg: dim(c.onSurface),
        border: null,
        overlay: c.onSurface.withValues(alpha: o.hover),
        shadow: c.onSurface.withValues(alpha: o.scrim),
        elevation: e.none,
      ),
      (UiButtonStyle.secondary, UiButtonRole.accent) => (
        bg: c.surfaceInteractive,
        disabledBg: dim(c.surfaceInteractive),
        fg: c.primary,
        disabledFg: dim(c.primary),
        border: null,
        overlay: c.primary.withValues(alpha: o.hover),
        shadow: c.primary.withValues(alpha: o.scrim),
        elevation: e.none,
      ),
      (UiButtonStyle.secondary, UiButtonRole.destructive) => (
        bg: c.errorContainer,
        disabledBg: dim(c.surfaceInteractive),
        fg: c.error,
        disabledFg: dim(c.error),
        border: null,
        overlay: c.error.withValues(alpha: o.hover),
        shadow: c.onSurface.withValues(alpha: o.scrim),
        elevation: e.none,
      ),
      // Outline
      (UiButtonStyle.outline, UiButtonRole.normal) => (
        bg: Colors.transparent,
        disabledBg: Colors.transparent,
        fg: c.onSurface,
        disabledFg: dim(c.onSurface),
        border: c.outline,
        overlay: c.onSurface.withValues(alpha: o.hover),
        shadow: Colors.transparent,
        elevation: e.none,
      ),
      (UiButtonStyle.outline, UiButtonRole.accent) => (
        bg: Colors.transparent,
        disabledBg: Colors.transparent,
        fg: c.primary,
        disabledFg: dim(c.primary),
        border: c.primary,
        overlay: c.primary.withValues(alpha: o.hover),
        shadow: Colors.transparent,
        elevation: e.none,
      ),
      (UiButtonStyle.outline, UiButtonRole.destructive) => (
        bg: Colors.transparent,
        disabledBg: Colors.transparent,
        fg: c.error,
        disabledFg: dim(c.error),
        border: c.error,
        overlay: c.error.withValues(alpha: o.hover),
        shadow: Colors.transparent,
        elevation: e.none,
      ),
      // Ghost
      (UiButtonStyle.ghost, UiButtonRole.normal) => (
        bg: Colors.transparent,
        disabledBg: Colors.transparent,
        fg: c.onSurface,
        disabledFg: dim(c.onSurface),
        border: null,
        overlay: c.onSurface.withValues(alpha: o.hover),
        shadow: Colors.transparent,
        elevation: e.none,
      ),
      (UiButtonStyle.ghost, UiButtonRole.accent) => (
        bg: Colors.transparent,
        disabledBg: Colors.transparent,
        fg: c.primary,
        disabledFg: dim(c.primary),
        border: null,
        overlay: c.primary.withValues(alpha: o.hover),
        shadow: Colors.transparent,
        elevation: e.none,
      ),
      (UiButtonStyle.ghost, UiButtonRole.destructive) => (
        bg: Colors.transparent,
        disabledBg: Colors.transparent,
        fg: c.error,
        disabledFg: dim(c.error),
        border: null,
        overlay: c.error.withValues(alpha: o.hover),
        shadow: Colors.transparent,
        elevation: e.none,
      ),
    };
  }

  ({
    Color bg,
    Color disabledBg,
    Color fg,
    Color disabledFg,
    Color? border,
    Color overlay,
    Color shadow,
    double elevation,
  })
  _applyColorOverrides(
    ({
      Color bg,
      Color disabledBg,
      Color fg,
      Color disabledFg,
      Color? border,
      Color overlay,
      Color shadow,
      double elevation,
    })
    resolvedColors,
  ) {
    final overrides = colors;

    if (overrides == null) {
      return resolvedColors;
    }

    return (
      bg: overrides.background ?? resolvedColors.bg,
      disabledBg: overrides.disabledBackground ?? resolvedColors.disabledBg,
      fg: overrides.foreground ?? resolvedColors.fg,
      disabledFg: overrides.disabledForeground ?? resolvedColors.disabledFg,
      border: overrides.border ?? resolvedColors.border,
      overlay: overrides.overlay ?? resolvedColors.overlay,
      shadow: overrides.shadow ?? resolvedColors.shadow,
      elevation: overrides.elevation ?? resolvedColors.elevation,
    );
  }

  Widget _buildLabelButton(
    UiTheme theme,
    ({
      Color bg,
      Color disabledBg,
      Color fg,
      Color disabledFg,
      Color? border,
      Color overlay,
      Color shadow,
      double elevation,
    })
    colors,
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
      disabledBackgroundColor: colors.disabledBg,
      foregroundColor: colors.fg,
      disabledForegroundColor: colors.disabledFg,
      overlayColor: colors.overlay,
      shape: shape,
      alignment: alignment,
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
            if (isLoading) UiLoader(size: size.loaderSize),
          ],
        ),
      ),
    );
  }

  Widget _buildIconButton(
    UiTheme theme,
    ({
      Color bg,
      Color disabledBg,
      Color fg,
      Color disabledFg,
      Color? border,
      Color overlay,
      Color shadow,
      double elevation,
    })
    colors,
  ) {
    final dimension = size.height;
    final iconSize = Size(dimension, dimension);

    return IconButton(
      onPressed: _enabled ? onPressed : null,
      icon: isLoading
          ? UiLoader(size: size.loaderSize, color: theme.color.onSurfaceMuted)
          : (icon ?? const SizedBox.shrink()),
      style: IconButton.styleFrom(
        splashFactory: NoSplash.splashFactory,
        fixedSize: iconSize,
        foregroundColor: colors.fg,
        disabledForegroundColor: colors.disabledFg,
        backgroundColor: colors.bg,
        disabledBackgroundColor: colors.disabledBg,
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
