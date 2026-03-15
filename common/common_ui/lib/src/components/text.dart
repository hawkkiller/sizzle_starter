import 'package:common_ui/common_ui.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

/// A themed text widget that maps semantic size presets to the design system typography.
class UiText extends StatefulWidget {
  // dart format off
  const UiText.displayLarge(this.text, {super.key, this.color, this.textAlign = TextAlign.start, this.overflow = TextOverflow.ellipsis, this.maxLines, this.selectable = false, this.emphasized = false, this.onTap}) : type = UiTypographySize.displayLarge;
  const UiText.displayMedium(this.text, {super.key, this.color, this.textAlign = TextAlign.start, this.overflow = TextOverflow.ellipsis, this.maxLines, this.selectable = false, this.emphasized = false, this.onTap}) : type = UiTypographySize.displayMedium;
  const UiText.displaySmall(this.text, {super.key, this.color, this.textAlign = TextAlign.start, this.overflow = TextOverflow.ellipsis, this.maxLines, this.selectable = false, this.emphasized = false, this.onTap}) : type = UiTypographySize.displaySmall;
  const UiText.headlineLarge(this.text, {super.key, this.color, this.textAlign = TextAlign.start, this.overflow = TextOverflow.ellipsis, this.maxLines, this.selectable = false, this.emphasized = false, this.onTap}) : type = UiTypographySize.headlineLarge;
  const UiText.headlineMedium(this.text, {super.key, this.color, this.textAlign = TextAlign.start, this.overflow = TextOverflow.ellipsis, this.maxLines, this.selectable = false, this.emphasized = false, this.onTap}) : type = UiTypographySize.headlineMedium;
  const UiText.headlineSmall(this.text, {super.key, this.color, this.textAlign = TextAlign.start, this.overflow = TextOverflow.ellipsis, this.maxLines, this.selectable = false, this.emphasized = false, this.onTap}) : type = UiTypographySize.headlineSmall;
  const UiText.titleLarge(this.text, {super.key, this.color, this.textAlign = TextAlign.start, this.overflow = TextOverflow.ellipsis, this.maxLines, this.selectable = false, this.emphasized = false, this.onTap}) : type = UiTypographySize.titleLarge;
  const UiText.titleMedium(this.text, {super.key, this.color, this.textAlign = TextAlign.start, this.overflow = TextOverflow.ellipsis, this.maxLines, this.selectable = false, this.emphasized = false, this.onTap}) : type = UiTypographySize.titleMedium;
  const UiText.titleSmall(this.text, {super.key, this.color, this.textAlign = TextAlign.start, this.overflow = TextOverflow.ellipsis, this.maxLines, this.selectable = false, this.emphasized = false, this.onTap}) : type = UiTypographySize.titleSmall;
  const UiText.bodyLarge(this.text, {super.key, this.color, this.textAlign = TextAlign.start, this.overflow = TextOverflow.ellipsis, this.maxLines, this.selectable = false, this.emphasized = false, this.onTap}) : type = UiTypographySize.bodyLarge;
  const UiText.bodyMedium(this.text, {super.key, this.color, this.textAlign = TextAlign.start, this.overflow = TextOverflow.ellipsis, this.maxLines, this.selectable = false, this.emphasized = false, this.onTap}) : type = UiTypographySize.bodyMedium;
  const UiText.bodySmall(this.text, {super.key, this.color, this.textAlign = TextAlign.start, this.overflow = TextOverflow.ellipsis, this.maxLines, this.selectable = false, this.emphasized = false, this.onTap}) : type = UiTypographySize.bodySmall;
  const UiText.labelLarge(this.text, {super.key, this.color, this.textAlign = TextAlign.start, this.overflow = TextOverflow.ellipsis, this.maxLines, this.selectable = false, this.emphasized = false, this.onTap}) : type = UiTypographySize.labelLarge;
  const UiText.labelMedium(this.text, {super.key, this.color, this.textAlign = TextAlign.start, this.overflow = TextOverflow.ellipsis, this.maxLines, this.selectable = false, this.emphasized = false, this.onTap}) : type = UiTypographySize.labelMedium;
  const UiText.labelSmall(this.text, {super.key, this.color, this.textAlign = TextAlign.start, this.overflow = TextOverflow.ellipsis, this.maxLines, this.selectable = false, this.emphasized = false, this.onTap}) : type = UiTypographySize.labelSmall;
  // dart format on

  /// The text content to display.
  final String text;

  /// Optional text color override.
  final Color? color;

  /// Horizontal alignment for the text.
  final TextAlign textAlign;

  /// How visual overflow should be handled for non-selectable text.
  final TextOverflow? overflow;

  /// Maximum number of lines to display.
  final int? maxLines;

  /// The semantic typography size to apply.
  final UiTypographySize type;

  /// Whether the text can be selected by the user.
  final bool selectable;

  /// Whether to use a slightly stronger font weight.
  final bool emphasized;

  /// Called when the text is tapped.
  ///
  /// When provided, the text is styled as a link.
  final VoidCallback? onTap;

  @override
  State<UiText> createState() => _UiTextState();
}

class _UiTextState extends State<UiText> {
  TapGestureRecognizer? _tapGestureRecognizer;

  bool get _isLink => widget.onTap != null;

  @override
  void initState() {
    super.initState();

    _updateTapGestureRecognizer();
  }

  @override
  void didUpdateWidget(covariant UiText oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.onTap != widget.onTap) {
      _updateTapGestureRecognizer();
    }
  }

  void _updateTapGestureRecognizer() {
    _tapGestureRecognizer?.dispose();
    _tapGestureRecognizer = null;

    if (widget.onTap != null) {
      _tapGestureRecognizer = TapGestureRecognizer()..onTap = widget.onTap;
    }
  }

  @override
  void dispose() {
    _tapGestureRecognizer?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = UiTheme.of(context);
    final colors = theme.color;
    final typography = theme.typography;
    final style = typography
        .getTextStyle(widget.type)
        .copyWith(
          color: widget.color ?? (_isLink ? colors.primary : colors.onSurface),
          fontWeight: widget.emphasized ? FontWeight.w500 : null,
          overflow: widget.overflow,
          decoration: _isLink ? TextDecoration.underline : null,
        );

    final span = TextSpan(
      text: widget.text,
      mouseCursor: widget.onTap != null ? SystemMouseCursors.click : null,
      recognizer: _tapGestureRecognizer,
      style: style,
    );

    if (widget.selectable) {
      return SelectableText.rich(
        span,
        textAlign: widget.textAlign,
        maxLines: widget.maxLines,
        selectionColor: colors.primary.withValues(alpha: 0.2),
      );
    }

    return Text.rich(
      span,
      textAlign: widget.textAlign,
      overflow: widget.overflow,
      maxLines: widget.maxLines,
      selectionColor: colors.primary.withValues(alpha: 0.2),
    );
  }
}
