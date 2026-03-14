import 'package:common_ui/common_ui.dart';
import 'package:flutter/material.dart';

/// A surfaced container for grouped menu content.
class UiMenu extends StatelessWidget {
  /// Creates a menu surface that arranges its [children] vertically.
  const UiMenu({
    required this.children,
    this.width,
    this.padding,
    super.key,
  });

  /// The widgets displayed inside the menu.
  final List<Widget> children;

  /// The optional width of the menu surface.
  final double? width;

  /// The padding applied inside the menu surface.
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final theme = UiTheme.of(context);

    return UiCard(
      hasShadow: true,
      padding: padding ?? EdgeInsets.all(theme.spacing.s8),
      child: SizedBox(
        width: width,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: children,
        ),
      ),
    );
  }
}

/// A full-width action row for menus.
class UiMenuItem extends StatelessWidget {
  /// Creates a menu action row.
  const UiMenuItem({
    required this.label,
    required this.onPressed,
    this.icon,
    this.trailing,
    this.role = UiButtonRole.normal,
    this.size = UiButtonSize.standard,
    this.enabled = true,
    super.key,
  });

  /// The accessible label shown for the action.
  final String label;

  /// Optional leading icon.
  final Widget? icon;

  /// Optional trailing widget.
  final Widget? trailing;

  /// The semantic role affecting the action color.
  final UiButtonRole role;

  /// The size of the action row.
  final UiButtonSize size;

  /// Whether the action is enabled.
  final bool enabled;

  /// Called when the action is pressed.
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return UiButton(
      label: label,
      icon: icon,
      trailing: trailing,
      style: UiButtonStyle.ghost,
      role: role,
      size: size,
      width: UiButtonWidth.fill,
      enabled: enabled,
      alignment: Alignment.centerLeft,
      onPressed: onPressed,
    );
  }
}

/// A separator between groups of menu content.
class UiMenuDivider extends StatelessWidget {
  /// Creates a menu divider.
  const UiMenuDivider({this.margin, super.key});

  /// The outer spacing around the divider line.
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    final theme = UiTheme.of(context);

    return Padding(
      padding: margin ?? EdgeInsets.symmetric(vertical: theme.spacing.s4),
      child: SizedBox(
        height: theme.borderWidth.subtle,
        child: ColoredBox(color: theme.color.outline),
      ),
    );
  }
}

/// A muted label that introduces a group of menu items.
class UiMenuSectionTitle extends StatelessWidget {
  /// Creates a section title for menu content.
  const UiMenuSectionTitle(this.label, {super.key});

  /// The text shown for the section.
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = UiTheme.of(context);

    return Padding(
      padding: EdgeInsets.fromLTRB(
        theme.spacing.s8,
        theme.spacing.s8,
        theme.spacing.s8,
        theme.spacing.s4,
      ),
      child: UiText.labelLarge(
        label,
        color: theme.color.onSurfaceMuted,
      ),
    );
  }
}
