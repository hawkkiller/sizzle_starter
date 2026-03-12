import 'package:common_ui/common_ui.dart';
import 'package:flutter/material.dart';

const _uiDialogTransitionDuration = Duration(milliseconds: 125);
const _uiDialogScaleBegin = 0.93;

/// Shows a modal dialog with the common UI transition and scrim treatment.
Future<T?> showUiDialog<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  bool barrierDismissible = true,
  String? barrierLabel,
  Color? barrierColor,
  bool useRootNavigator = true,
  bool useSafeArea = true,
  RouteSettings? routeSettings,
  AlignmentGeometry alignment = Alignment.center,
  EdgeInsetsGeometry insetPadding = const EdgeInsets.all(24),
}) {
  final theme = UiTheme.of(context);
  final effectiveBarrierLabel = barrierDismissible
      ? (barrierLabel ?? MaterialLocalizations.of(context).modalBarrierDismissLabel)
      : barrierLabel;

  return showGeneralDialog<T>(
    context: context,
    barrierDismissible: barrierDismissible,
    barrierLabel: effectiveBarrierLabel,
    barrierColor: Colors.transparent,
    transitionDuration: _uiDialogTransitionDuration,
    routeSettings: routeSettings,
    useRootNavigator: useRootNavigator,
    pageBuilder: (dialogContext, animation, secondaryAnimation) {
      return Builder(builder: builder);
    },
    transitionBuilder: (dialogContext, animation, secondaryAnimation, child) {
      void dismissBarrier() {
        Navigator.of(dialogContext, rootNavigator: useRootNavigator).maybePop();
      }

      final resolvedAlignment = alignment.resolve(Directionality.of(dialogContext));
      final curvedAnimation = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOut,
        reverseCurve: Curves.easeOut,
      );
      final scrimAnimation = ColorTween(
        begin: Colors.transparent,
        end: barrierColor ?? theme.color.scrim.withValues(alpha: .2),
      ).animate(curvedAnimation);
      final scaleAnimation = Tween<double>(begin: _uiDialogScaleBegin, end: 1).animate(
        curvedAnimation,
      );

      return AnimatedBuilder(
        animation: scrimAnimation,
        builder: (context, _) {
          return Stack(
            fit: StackFit.expand,
            children: [
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: barrierDismissible ? dismissBarrier : null,
                child: ColoredBox(color: scrimAnimation.value ?? Colors.transparent),
              ),
              _UiDialogRouteLayout(
                alignment: alignment,
                insetPadding: insetPadding,
                useSafeArea: useSafeArea,
                child: FadeTransition(
                  opacity: curvedAnimation,
                  child: ScaleTransition(
                    alignment: resolvedAlignment,
                    scale: scaleAnimation,
                    child: child,
                  ),
                ),
              ),
            ],
          );
        },
      );
    },
  );
}

/// A surfaced container intended for modal dialog content.
class UiDialog extends StatelessWidget {
  /// Creates a surfaced dialog container.
  const UiDialog({
    required this.child,
    this.width = 420,
    this.constraints,
    this.padding,
    this.color,
    this.hasBorder = true,
    super.key,
  });

  /// The dialog content.
  final Widget child;

  /// The preferred maximum width of the dialog.
  final double? width;

  /// Optional constraints applied to the dialog surface.
  final BoxConstraints? constraints;

  /// The padding applied inside the dialog surface.
  final EdgeInsetsGeometry? padding;

  /// The surface color of the dialog.
  final Color? color;

  /// Whether the dialog surface shows a border.
  final bool hasBorder;

  @override
  Widget build(BuildContext context) {
    final theme = UiTheme.of(context);

    return ConstrainedBox(
      constraints: constraints ?? BoxConstraints(maxWidth: width ?? double.infinity),
      child: UiCard(
        hasBorder: hasBorder,
        color: color ?? theme.color.surfaceRaised,
        borderRadius: BorderRadius.circular(theme.radius.dialog),
        padding: padding ?? EdgeInsets.all(theme.spacing.s24),
        child: child,
      ),
    );
  }
}

/// A standard header block for dialog title, description, and trailing actions.
class UiDialogHeader extends StatelessWidget {
  /// Creates a dialog header.
  const UiDialogHeader({
    required this.title,
    this.description,
    this.trailing,
    super.key,
  });

  /// The primary dialog title.
  final String title;

  /// The optional supporting description shown below the title.
  final String? description;

  /// An optional trailing widget, such as a dismiss button.
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final theme = UiTheme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          spacing: theme.spacing.s12,
          children: [
            Expanded(child: UiText.titleLarge(title)),
            if (trailing != null) trailing!,
          ],
        ),
        if (description != null) ...[
          SizedBox(height: theme.spacing.s8),
          UiText.bodyMedium(
            description!,
            color: theme.color.onSurfaceMuted,
            overflow: TextOverflow.visible,
          ),
        ],
      ],
    );
  }
}

/// A standard content block for dialog body content.
class UiDialogBody extends StatelessWidget {
  /// Creates a dialog body with custom content.
  const UiDialogBody({required this.child, super.key}) : text = null;

  /// Creates a dialog body with standard supporting text.
  const UiDialogBody.text(this.text, {super.key}) : child = null;

  /// Optional custom body content.
  final Widget? child;

  /// Optional supporting text rendered with dialog body styling.
  final String? text;

  @override
  Widget build(BuildContext context) {
    final theme = UiTheme.of(context);

    if (text != null) {
      return UiText.bodyMedium(
        text!,
        color: theme.color.onSurfaceMuted,
        overflow: TextOverflow.visible,
      );
    }

    return child!;
  }
}

/// A standard trailing action row for dialogs.
class UiDialogActions extends StatelessWidget {
  /// Creates a dialog action row.
  const UiDialogActions({
    required this.children,
    this.spacing,
    this.runSpacing,
    super.key,
  });

  /// The action buttons shown at the bottom of the dialog.
  final List<Widget> children;

  /// The horizontal spacing between actions.
  final double? spacing;

  /// The vertical spacing used when actions wrap onto another line.
  final double? runSpacing;

  @override
  Widget build(BuildContext context) {
    final theme = UiTheme.of(context);

    return Align(
      alignment: Alignment.centerRight,
      child: Wrap(
        alignment: WrapAlignment.end,
        spacing: spacing ?? theme.spacing.s8,
        runSpacing: runSpacing ?? theme.spacing.s8,
        children: children,
      ),
    );
  }
}

/// A ready-to-use confirmation dialog that returns `true` when confirmed.
class UiConfirmDialog extends StatelessWidget {
  /// Creates a confirmation dialog.
  const UiConfirmDialog({
    required this.title,
    this.description,
    this.content,
    this.confirmLabel,
    this.cancelLabel,
    this.confirmRole = UiButtonRole.normal,
    this.confirmStyle = UiButtonStyle.primary,
    this.cancelStyle = UiButtonStyle.ghost,
    super.key,
  });

  /// The primary confirmation title.
  final String title;

  /// Optional supporting text shown below the title.
  final String? description;

  /// Optional custom content shown above the actions.
  final Widget? content;

  /// The label used for the confirm action.
  final String? confirmLabel;

  /// The label used for the cancel action.
  final String? cancelLabel;

  /// The semantic role applied to the confirm action.
  final UiButtonRole confirmRole;

  /// The visual style used for the confirm action.
  final UiButtonStyle confirmStyle;

  /// The visual style used for the cancel action.
  final UiButtonStyle cancelStyle;

  @override
  Widget build(BuildContext context) {
    final theme = UiTheme.of(context);
    final hasBody = description != null || content != null;

    return UiDialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          UiDialogHeader(title: title),
          if (hasBody) ...[
            SizedBox(height: theme.spacing.s16),
            if (description != null) UiDialogBody.text(description),
            if (description != null && content != null) SizedBox(height: theme.spacing.s16),
            if (content != null) UiDialogBody(child: content),
          ],
          SizedBox(height: theme.spacing.s16),
          UiDialogActions(
            children: [
              UiButton(
                label: cancelLabel ?? 'Cancel', // TODO(mlazebny): translations
                style: cancelStyle,
                onPressed: () => Navigator.of(context).pop(false),
              ),
              UiButton(
                label: confirmLabel ?? 'Confirm',
                style: confirmStyle,
                role: confirmRole,
                onPressed: () => Navigator.of(context).pop(true),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _UiDialogRouteLayout extends StatelessWidget {
  const _UiDialogRouteLayout({
    required this.child,
    required this.alignment,
    required this.insetPadding,
    required this.useSafeArea,
  });

  final Widget child;
  final AlignmentGeometry alignment;
  final EdgeInsetsGeometry insetPadding;
  final bool useSafeArea;

  @override
  Widget build(BuildContext context) {
    final direction = Directionality.of(context);
    final viewInsets = MediaQuery.viewInsetsOf(context);

    Widget current = Align(alignment: alignment, child: child);
    current = Padding(padding: viewInsets, child: current);
    current = Padding(padding: insetPadding.resolve(direction), child: current);
    current = Semantics(scopesRoute: true, explicitChildNodes: true, child: current);

    if (useSafeArea) {
      current = SafeArea(child: current);
    }

    return Material(type: MaterialType.transparency, child: current);
  }
}
