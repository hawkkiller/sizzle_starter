import 'dart:async';
import 'dart:collection';
import 'dart:math' as math;

import 'package:common_ui/common_ui.dart';
import 'package:flutter/material.dart';

const _uiSnackbarAnimationDuration = Duration(milliseconds: 125);
const _uiSnackbarDefaultDuration = Duration(seconds: 4);
const _uiSnackbarMaxWidth = 560.0;

/// The visual variant of a snackbar.
enum UiSnackbarVariant {
  neutral,
  info,
  success,
  warning,
  error,
}

/// Shows a snackbar using the nearest [UiSnackbarHost].
void showUiSnackbar(
  BuildContext context, {
  required String message,
  UiSnackbarAction? action,
  UiSnackbarVariant variant = UiSnackbarVariant.neutral,
  Duration? duration,
}) {
  UiSnackbarScope.of(context, listen: false).controller.show(
    UiSnackbarData(
      message: message,
      action: action,
      variant: variant,
      duration: duration,
    ),
  );
}

/// The action shown in a [UiSnackbar].
@immutable
class UiSnackbarAction {
  /// Creates a snackbar action.
  const UiSnackbarAction({required this.label, required this.onPressed});

  /// The action label.
  final String label;

  /// Called when the action is pressed.
  final VoidCallback onPressed;
}

/// The data used to show a snackbar.
@immutable
class UiSnackbarData {
  /// Creates snackbar data.
  const UiSnackbarData({
    required this.message,
    this.action,
    this.variant = UiSnackbarVariant.neutral,
    this.duration,
  });

  /// The message shown in the snackbar.
  final String message;

  /// The optional action shown after the message.
  final UiSnackbarAction? action;

  /// The visual variant of the snackbar.
  final UiSnackbarVariant variant;

  /// The optional time the snackbar stays visible before dismissing itself.
  final Duration? duration;
}

/// A controller that manages snackbar presentation.
abstract interface class UiSnackbarController {
  /// Shows a snackbar.
  void show(UiSnackbarData snackbar);

  /// Dismisses the current snackbar.
  void hideCurrent();

  /// Clears the pending snackbar queue.
  void clearQueue();
}

/// Provides access to the nearest [UiSnackbarController].
class UiSnackbarScope extends InheritedWidget {
  /// Creates a snackbar scope.
  const UiSnackbarScope({
    required this.controller,
    required super.child,
    super.key,
  });

  /// The snackbar controller.
  final UiSnackbarController controller;

  /// Returns the nearest [UiSnackbarScope], if one exists.
  static UiSnackbarScope? maybeOf(BuildContext context, {bool listen = true}) {
    return listen
        ? context.dependOnInheritedWidgetOfExactType<UiSnackbarScope>()
        : context.getInheritedWidgetOfExactType<UiSnackbarScope>();
  }

  /// Returns the nearest [UiSnackbarScope].
  static UiSnackbarScope of(BuildContext context, {bool listen = true}) {
    final scope = maybeOf(context, listen: listen);
    assert(scope != null, 'No UiSnackbarScope found in context.');
    return scope!;
  }

  @override
  bool updateShouldNotify(covariant UiSnackbarScope oldWidget) {
    return controller != oldWidget.controller;
  }
}

/// Hosts snackbars above the current subtree.
///
/// Place this widget high in the tree, typically in `MaterialApp.builder`,
/// so the snackbar can appear above the active page content.
class UiSnackbarHost extends StatefulWidget {
  /// Creates a snackbar host.
  const UiSnackbarHost({required this.child, super.key});

  /// The widget below this host.
  final Widget child;

  @override
  State<UiSnackbarHost> createState() => _UiSnackbarHostState();
}

class _UiSnackbarHostState extends State<UiSnackbarHost>
    with SingleTickerProviderStateMixin
    implements UiSnackbarController {
  final Queue<UiSnackbarData> _queue = Queue<UiSnackbarData>();

  late final AnimationController _animationController;
  late final Animation<double> _opacityAnimation;
  late final Animation<Offset> _offsetAnimation;

  Timer? _dismissTimer;
  UiSnackbarData? _currentSnackbar;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: _uiSnackbarAnimationDuration,
      vsync: this,
    );
    final curvedAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
      reverseCurve: Curves.easeIn,
    );
    _opacityAnimation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);
    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0, 0.12),
      end: Offset.zero,
    ).animate(curvedAnimation);
  }

  @override
  void dispose() {
    _dismissTimer?.cancel();
    _animationController.dispose();
    super.dispose();
  }

  @override
  void show(UiSnackbarData snackbar) {
    _queue.addLast(snackbar);
    _showNextIfIdle();
  }

  @override
  void hideCurrent() {
    _dismissTimer?.cancel();

    if (_currentSnackbar == null || _animationController.status == AnimationStatus.reverse) {
      return;
    }

    unawaited(_dismissCurrent());
  }

  @override
  void clearQueue() {
    _queue.clear();
  }

  void _showNextIfIdle() {
    if (_currentSnackbar != null || _queue.isEmpty) {
      return;
    }

    setState(() {
      _currentSnackbar = _queue.removeFirst();
    });

    unawaited(_animationController.forward(from: 0));
    _scheduleDismiss();
  }

  void _scheduleDismiss() {
    _dismissTimer?.cancel();
    final duration = _currentSnackbar?.duration ?? _uiSnackbarDefaultDuration;
    _dismissTimer = Timer(duration, hideCurrent);
  }

  Future<void> _dismissCurrent() async {
    await _animationController.reverse();

    if (!mounted) {
      return;
    }

    setState(() {
      _currentSnackbar = null;
    });

    _showNextIfIdle();
  }

  void _handleActionPressed(UiSnackbarAction action) {
    action.onPressed();
    hideCurrent();
  }

  @override
  Widget build(BuildContext context) {
    return UiSnackbarScope(
      controller: this,
      child: Stack(
        fit: StackFit.expand,
        children: [
          widget.child,
          _UiSnackbarLayer(
            snackbar: _currentSnackbar,
            opacityAnimation: _opacityAnimation,
            offsetAnimation: _offsetAnimation,
            onActionPressed: _handleActionPressed,
          ),
        ],
      ),
    );
  }
}

class _UiSnackbarLayer extends StatelessWidget {
  const _UiSnackbarLayer({
    required this.snackbar,
    required this.opacityAnimation,
    required this.offsetAnimation,
    required this.onActionPressed,
  });

  final UiSnackbarData? snackbar;
  final Animation<double> opacityAnimation;
  final Animation<Offset> offsetAnimation;
  final ValueChanged<UiSnackbarAction> onActionPressed;

  @override
  Widget build(BuildContext context) {
    if (snackbar == null) {
      return const SizedBox.shrink();
    }

    final theme = UiTheme.of(context);
    final mediaQuery = MediaQuery.of(context);
    final bottomInset = math.max(mediaQuery.viewPadding.bottom, mediaQuery.viewInsets.bottom);

    return Positioned.fill(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: EdgeInsets.only(
            left: mediaQuery.viewPadding.left + theme.spacing.s16,
            right: mediaQuery.viewPadding.right + theme.spacing.s16,
            bottom: bottomInset + theme.spacing.s16,
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: _uiSnackbarMaxWidth),
            child: FadeTransition(
              opacity: opacityAnimation,
              child: SlideTransition(
                position: offsetAnimation,
                child: UiSnackbar(
                  snackbar: snackbar!,
                  onActionPressed: onActionPressed,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// A surfaced snackbar with an optional action.
class UiSnackbar extends StatelessWidget {
  /// Creates a snackbar surface.
  const UiSnackbar({
    required this.snackbar,
    this.onActionPressed,
    super.key,
  });

  /// The snackbar content.
  final UiSnackbarData snackbar;

  /// Called when the snackbar action is pressed.
  final ValueChanged<UiSnackbarAction>? onActionPressed;

  @override
  Widget build(BuildContext context) {
    final theme = UiTheme.of(context);
    final colors = _resolveColors(theme);

    return Semantics(
      container: true,
      liveRegion: true,
      child: UiCard(
        hasShadow: true,
        color: colors.background,
        borderRadius: BorderRadius.circular(theme.radius.dialog),
        padding: EdgeInsets.symmetric(
          horizontal: theme.spacing.s16,
          vertical: theme.spacing.s12,
        ),
        child: DefaultTextStyle(
          style: theme.typography.bodyMedium.copyWith(color: colors.foreground),
          child: _UiSnackbarContent(
            snackbar: snackbar,
            onActionPressed: onActionPressed,
          ),
        ),
      ),
    );
  }

  ({Color background, Color foreground}) _resolveColors(UiTheme theme) {
    final color = theme.color;

    return switch (snackbar.variant) {
      UiSnackbarVariant.neutral => (
        background: color.surfaceRaised,
        foreground: color.onSurface,
      ),
      UiSnackbarVariant.info => (
        background: color.infoContainer,
        foreground: color.onInfoContainer,
      ),
      UiSnackbarVariant.success => (
        background: color.successContainer,
        foreground: color.onSuccessContainer,
      ),
      UiSnackbarVariant.warning => (
        background: color.warningContainer,
        foreground: color.onWarningContainer,
      ),
      UiSnackbarVariant.error => (
        background: color.errorContainer,
        foreground: color.onErrorContainer,
      ),
    };
  }
}

class _UiSnackbarContent extends StatelessWidget {
  const _UiSnackbarContent({
    required this.snackbar,
    this.onActionPressed,
  });

  final UiSnackbarData snackbar;
  final ValueChanged<UiSnackbarAction>? onActionPressed;

  ({UiButtonStyle style, UiButtonRole role}) _resolveActionAppearance() {
    return switch (snackbar.variant) {
      UiSnackbarVariant.neutral => (style: UiButtonStyle.ghost, role: UiButtonRole.normal),
      UiSnackbarVariant.info => (style: UiButtonStyle.secondary, role: UiButtonRole.normal),
      UiSnackbarVariant.success => (style: UiButtonStyle.secondary, role: UiButtonRole.normal),
      UiSnackbarVariant.warning => (style: UiButtonStyle.secondary, role: UiButtonRole.normal),
      UiSnackbarVariant.error => (style: UiButtonStyle.outline, role: UiButtonRole.destructive),
    };
  }

  @override
  Widget build(BuildContext context) {
    final theme = UiTheme.of(context);
    final actionAppearance = _resolveActionAppearance();

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          snackbar.message,
          overflow: TextOverflow.visible,
          maxLines: 3,
        ),
        if (snackbar.action != null) ...[
          SizedBox(height: theme.spacing.s8),
          Align(
            alignment: Alignment.centerRight,
            child: UiButton(
              label: snackbar.action!.label,
              style: actionAppearance.style,
              role: actionAppearance.role,
              emphasized: true,
              onPressed: onActionPressed == null ? null : () => onActionPressed!(snackbar.action!),
            ),
          ),
        ],
      ],
    );
  }
}
