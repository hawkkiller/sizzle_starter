import 'dart:ui' show lerpDouble;

import 'package:common_ui/common_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A selectable row layout for list content and lightweight actions.
class UiListItem extends StatelessWidget {
  /// Creates a list item.
  const UiListItem({
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.onPressed,
    this.enabled = true,
    this.selected = false,
    this.contentPadding,
    super.key,
  });

  /// The primary text displayed by the item.
  final String title;

  /// Optional supporting text shown below the title.
  final String? subtitle;

  /// Optional leading widget, typically an icon or avatar.
  final Widget? leading;

  /// Optional trailing widget, typically metadata or an icon.
  final Widget? trailing;

  /// Called when the item is activated.
  final VoidCallback? onPressed;

  /// Whether the item is enabled.
  final bool enabled;

  /// Whether the item is visually selected.
  final bool selected;

  /// Optional padding applied around the item content.
  final EdgeInsetsGeometry? contentPadding;

  bool get _isInteractive => enabled && onPressed != null;

  @override
  Widget build(BuildContext context) {
    final theme = UiTheme.of(context);
    final titleColor = selected ? theme.color.onPrimaryContainer : theme.color.onSurface;
    final subtitleColor = selected
        ? theme.color.onPrimaryContainer.withValues(alpha: 0.72)
        : theme.color.onSurfaceMuted;
    final accessoryColor = selected ? theme.color.onPrimaryContainer : theme.color.onSurfaceMuted;
    final backgroundColor = selected ? theme.color.primaryContainer : Colors.transparent;
    final overlayColor = selected ? theme.color.onPrimaryContainer : theme.color.onSurface;

    Widget child = _UiListItemSurface(
      backgroundColor: backgroundColor,
      hasSubtitle: subtitle != null,
      contentPadding: contentPadding,
      child: _UiListItemContent(
        title: title,
        subtitle: subtitle,
        leading: leading,
        trailing: trailing,
        titleColor: titleColor,
        subtitleColor: subtitleColor,
        accessoryColor: accessoryColor,
      ),
    );

    if (_isInteractive) {
      child = _UiListItemButton(
        backgroundColor: backgroundColor,
        overlayColor: overlayColor,
        onPressed: onPressed!,
        hasSubtitle: subtitle != null,
        contentPadding: contentPadding,
        child: _UiListItemContent(
          title: title,
          subtitle: subtitle,
          leading: leading,
          trailing: trailing,
          titleColor: titleColor,
          subtitleColor: subtitleColor,
          accessoryColor: accessoryColor,
        ),
      );
    }

    if (!enabled) {
      child = Opacity(opacity: theme.opacity.disabled, child: child);
    }

    return Semantics(
      button: onPressed != null,
      enabled: _isInteractive,
      selected: selected,
      child: child,
    );
  }
}

class _UiListItemButton extends StatefulWidget {
  const _UiListItemButton({
    required this.backgroundColor,
    required this.overlayColor,
    required this.onPressed,
    required this.hasSubtitle,
    required this.child,
    this.contentPadding,
  });

  final Color backgroundColor;
  final Color overlayColor;
  final VoidCallback onPressed;
  final bool hasSubtitle;
  final Widget child;
  final EdgeInsetsGeometry? contentPadding;

  @override
  State<_UiListItemButton> createState() => _UiListItemButtonState();
}

class _UiListItemButtonState extends State<_UiListItemButton> {
  bool _isFocused = false;
  bool _isHovered = false;

  double _baseOverlayOpacity(UiTheme theme) {
    if (_isHovered) {
      return theme.opacity.hover;
    }

    if (_isFocused) {
      return theme.opacity.focus;
    }

    return 0;
  }

  Color _resolvedBackgroundColor(UiTheme theme, double pressProgress) {
    final overlayOpacity =
        lerpDouble(_baseOverlayOpacity(theme), theme.opacity.pressed, pressProgress) ?? 0;

    if (overlayOpacity == 0) {
      return widget.backgroundColor;
    }

    return Color.alphaBlend(
      widget.overlayColor.withValues(alpha: overlayOpacity),
      widget.backgroundColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = UiTheme.of(context);

    return FocusableActionDetector(
      mouseCursor: SystemMouseCursors.click,
      onShowFocusHighlight: (value) => setState(() => _isFocused = value),
      onShowHoverHighlight: (value) => setState(() => _isHovered = value),
      shortcuts: const <ShortcutActivator, Intent>{
        SingleActivator(LogicalKeyboardKey.enter): ActivateIntent(),
        SingleActivator(LogicalKeyboardKey.space): ActivateIntent(),
      },
      actions: <Type, Action<Intent>>{
        ActivateIntent: CallbackAction<ActivateIntent>(
          onInvoke: (intent) {
            widget.onPressed();
            return null;
          },
        ),
      },
      child: PressTransition(
        onTap: widget.onPressed,
        child: widget.child,
        builder: (context, pressProgress, child) {
          return Transform.scale(
            scale: lerpDouble(1, 0.97, pressProgress) ?? 1,
            child: _UiListItemSurface(
              backgroundColor: _resolvedBackgroundColor(theme, pressProgress),
              hasSubtitle: widget.hasSubtitle,
              contentPadding: widget.contentPadding,
              child: child!,
            ),
          );
        },
      ),
    );
  }
}

class _UiListItemSurface extends StatelessWidget {
  const _UiListItemSurface({
    required this.backgroundColor,
    required this.hasSubtitle,
    required this.child,
    this.contentPadding,
  });

  final Color backgroundColor;
  final bool hasSubtitle;
  final Widget child;
  final EdgeInsetsGeometry? contentPadding;

  @override
  Widget build(BuildContext context) {
    final theme = UiTheme.of(context);
    return DecoratedBox(
      decoration: ShapeDecoration(
        color: backgroundColor,
        shape: RoundedSuperellipseBorder(
          borderRadius: BorderRadius.circular(theme.radius.component),
        ),
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: hasSubtitle ? 64 : 48),
        child: Padding(
          padding:
              contentPadding ??
              EdgeInsets.symmetric(horizontal: theme.spacing.s16, vertical: theme.spacing.s12),
          child: child,
        ),
      ),
    );
  }
}

class _UiListItemContent extends StatelessWidget {
  const _UiListItemContent({
    required this.title,
    required this.titleColor,
    required this.subtitleColor,
    required this.accessoryColor,
    this.subtitle,
    this.leading,
    this.trailing,
  });

  final String title;
  final String? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final Color titleColor;
  final Color subtitleColor;
  final Color accessoryColor;

  @override
  Widget build(BuildContext context) {
    final theme = UiTheme.of(context);

    return Row(
      children: [
        if (leading != null) ...[
          IconTheme(
            data: IconThemeData(color: accessoryColor, size: 20),
            child: DefaultTextStyle.merge(
              style: theme.typography.bodyMedium.copyWith(color: accessoryColor),
              child: leading!,
            ),
          ),
          SizedBox(width: theme.spacing.s12),
        ],
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.typography.bodyLarge.copyWith(color: titleColor),
              ),
              if (subtitle != null) ...[
                SizedBox(height: theme.spacing.s2),
                Text(
                  subtitle!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.typography.bodySmall.copyWith(color: subtitleColor),
                ),
              ],
            ],
          ),
        ),
        if (trailing != null) ...[
          SizedBox(width: theme.spacing.s12),
          IconTheme(
            data: IconThemeData(color: accessoryColor, size: 20),
            child: DefaultTextStyle.merge(
              style: theme.typography.bodyMedium.copyWith(color: accessoryColor),
              child: trailing!,
            ),
          ),
        ],
      ],
    );
  }
}
