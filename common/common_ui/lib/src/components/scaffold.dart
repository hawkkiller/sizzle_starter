import 'package:common_ui/common_ui.dart';
import 'package:flutter/material.dart';

/// A thin scaffold wrapper that hosts snackbars for the current screen.
class UiScaffold extends StatelessWidget {
  /// Creates a UI scaffold.
  const UiScaffold({
    required this.body,
    this.appBar,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.backgroundColor,
    this.resizeToAvoidBottomInset,
    this.extendBody = false,
    this.extendBodyBehindAppBar = false,
    super.key,
  });

  /// The primary content of the scaffold.
  final Widget body;

  /// An optional app bar displayed above the [body].
  final PreferredSizeWidget? appBar;

  /// An optional bottom navigation bar.
  final Widget? bottomNavigationBar;

  /// An optional floating action button.
  final Widget? floatingActionButton;

  /// The background color of the scaffold.
  final Color? backgroundColor;

  /// Whether the body should size itself to avoid the onscreen keyboard.
  final bool? resizeToAvoidBottomInset;

  /// Whether the body extends to the bottom of the scaffold.
  final bool extendBody;

  /// Whether the body extends behind the app bar.
  final bool extendBodyBehindAppBar;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButton: floatingActionButton,
      backgroundColor: backgroundColor ?? UiTheme.of(context).color.background,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      extendBody: extendBody,
      extendBodyBehindAppBar: extendBodyBehindAppBar,
      body: UiSnackbarHost(child: body),
    );
  }
}
