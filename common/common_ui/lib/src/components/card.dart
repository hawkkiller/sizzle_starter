import 'package:common_ui/common_ui.dart';
import 'package:flutter/material.dart';

class UiCard extends StatelessWidget {
  const UiCard({
    required this.child,
    this.hasBorder = false,
    this.borderRadius,
    this.margin = EdgeInsets.zero,
    this.padding,
    this.height,
    this.width,
    this.color,
    super.key,
  });

  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry? padding;
  final BorderRadiusGeometry? borderRadius;
  final double? height;
  final double? width;
  final Color? color;
  final bool hasBorder;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = UiTheme.of(context);

    final side = hasBorder
        ? BorderSide(color: theme.color.outline, width: theme.borderWidth.subtle)
        : BorderSide.none;

    return Padding(
      padding: margin,
      child: SizedBox(
        width: width,
        height: height,
        child: DecoratedBox(
          decoration: ShapeDecoration(
            color: color ?? theme.color.surface,
            shape: RoundedSuperellipseBorder(
              side: side,
              borderRadius: borderRadius ?? BorderRadius.circular(theme.radius.container),
            ),
          ),
          child: Padding(
            padding: padding ?? EdgeInsets.all(theme.spacing.s16),
            child: child,
          ),
        ),
      ),
    );
  }
}
