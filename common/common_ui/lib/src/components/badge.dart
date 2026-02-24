import 'package:common_ui/common_ui.dart';
import 'package:flutter/widgets.dart';

enum UiBadgeVariant { neutral, info, warning, success }

class UiBadge extends StatelessWidget {
  const UiBadge({
    required this.label,
    this.variant = UiBadgeVariant.info,
    this.spacious = false,
    this.borderRadius,
    super.key,
  });

  final UiBadgeVariant variant;
  final bool spacious;
  final BorderRadiusGeometry? borderRadius;
  final String label;

  Color _getBackgroundColor(UiTheme theme) => switch (variant) {
    UiBadgeVariant.neutral => theme.color.surface,
    UiBadgeVariant.info => theme.color.infoContainer,
    UiBadgeVariant.warning => theme.color.warningContainer,
    UiBadgeVariant.success => theme.color.successContainer,
  };

  Color _getForegroundColor(UiTheme theme) => switch (variant) {
    UiBadgeVariant.neutral => theme.color.onSurfaceMuted,
    UiBadgeVariant.info => theme.color.onInfoContainer,
    UiBadgeVariant.warning => theme.color.onWarningContainer,
    UiBadgeVariant.success => theme.color.onSuccessContainer,
  };

  EdgeInsets _getPadding(UiTheme theme) => EdgeInsets.symmetric(
    horizontal: spacious ? theme.spacing.s8 : theme.spacing.s4,
    vertical: theme.spacing.s2,
  );

  Widget _buildLabel(UiTheme theme, Color foregroundColor) => spacious
      ? Text(label, style: theme.typography.labelLarge.copyWith(color: foregroundColor))
      : Text(label, style: theme.typography.labelMedium.copyWith(color: foregroundColor));

  @override
  Widget build(BuildContext context) {
    final theme = UiTheme.of(context);

    final backgroundColor = _getBackgroundColor(theme);
    final foregroundColor = _getForegroundColor(theme);

    return DecoratedBox(
      decoration: ShapeDecoration(
        shape: RoundedSuperellipseBorder(
          borderRadius: BorderRadius.circular(theme.radius.full),
        ),
        color: backgroundColor,
      ),
      child: Padding(
        padding: _getPadding(theme),
        child: _buildLabel(theme, foregroundColor),
      ),
    );
  }
}
