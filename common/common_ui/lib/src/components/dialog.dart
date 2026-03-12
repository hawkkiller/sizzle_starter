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
