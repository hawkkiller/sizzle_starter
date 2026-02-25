import 'package:common_ui/common_ui.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class UiText extends StatefulWidget {
  // dart format off
  const UiText.headlineLarge(this.text, {this.color, this.textAlign = TextAlign.start, this.overflow = TextOverflow.ellipsis, this.maxLines, this.link, this.selectable = false, this.emphasized = false, this.onTap}) : type = UiTypographySize.headlineLarge;
  const UiText.headlineMedium(this.text, {this.color, this.textAlign = TextAlign.start, this.overflow = TextOverflow.ellipsis, this.maxLines, this.link, this.selectable = false, this.emphasized = false, this.onTap}) : type = UiTypographySize.headlineMedium;
  const UiText.headlineSmall(this.text, {this.color, this.textAlign = TextAlign.start, this.overflow = TextOverflow.ellipsis, this.maxLines, this.link, this.selectable = false, this.emphasized = false, this.onTap}) : type = UiTypographySize.headlineSmall;
  const UiText.titleLarge(this.text, {this.color, this.textAlign = TextAlign.start, this.overflow = TextOverflow.ellipsis, this.maxLines, this.link, this.selectable = false, this.emphasized = false, this.onTap}) : type = UiTypographySize.titleLarge;
  const UiText.titleMedium(this.text, {this.color, this.textAlign = TextAlign.start, this.overflow = TextOverflow.ellipsis, this.maxLines, this.link, this.selectable = false, this.emphasized = false, this.onTap}) : type = UiTypographySize.titleMedium;
  const UiText.titleSmall(this.text, {this.color, this.textAlign = TextAlign.start, this.overflow = TextOverflow.ellipsis, this.maxLines, this.link, this.selectable = false, this.emphasized = false, this.onTap}) : type = UiTypographySize.titleSmall;
  const UiText.bodyLarge(this.text, {this.color, this.textAlign = TextAlign.start, this.overflow = TextOverflow.ellipsis, this.maxLines, this.link, this.selectable = false, this.emphasized = false, this.onTap}) : type = UiTypographySize.bodyLarge;
  const UiText.bodyMedium(this.text, {this.color, this.textAlign = TextAlign.start, this.overflow = TextOverflow.ellipsis, this.maxLines, this.link, this.selectable = false, this.emphasized = false, this.onTap}) : type = UiTypographySize.bodyMedium;
  const UiText.bodySmall(this.text, {this.color, this.textAlign = TextAlign.start, this.overflow = TextOverflow.ellipsis, this.maxLines, this.link, this.selectable = false, this.emphasized = false, this.onTap}) : type = UiTypographySize.bodySmall;
  const UiText.labelLarge(this.text, {this.color, this.textAlign = TextAlign.start, this.overflow = TextOverflow.ellipsis, this.maxLines, this.link, this.selectable = false, this.emphasized = false, this.onTap}) : type = UiTypographySize.labelLarge;
  const UiText.labelMedium(this.text, {this.color, this.textAlign = TextAlign.start, this.overflow = TextOverflow.ellipsis, this.maxLines, this.link, this.selectable = false, this.emphasized = false, this.onTap}) : type = UiTypographySize.labelMedium;
  const UiText.labelSmall(this.text, {this.color, this.textAlign = TextAlign.start, this.overflow = TextOverflow.ellipsis, this.maxLines, this.link, this.selectable = false, this.emphasized = false, this.onTap}) : type = UiTypographySize.labelSmall;
  // dart format on

  final String text;
  final Color? color;
  final TextAlign textAlign;
  final TextOverflow? overflow;
  final int? maxLines;
  final UiTypographySize type;
  final bool selectable;
  final bool emphasized;
  final String? link;
  final VoidCallback? onTap;

  @override
  State<UiText> createState() => _UiTextState();
}

class _UiTextState extends State<UiText> {
  TapGestureRecognizer? _tapGestureRecognizer;

  @override
  void initState() {
    super.initState();

    if (widget.link != null) {
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
          color: widget.color ?? colors.onSurface,
          fontWeight: widget.emphasized ? FontWeight.w500 : null,
        );

    final span = TextSpan(
      text: widget.text,
      mouseCursor: widget.link != null ? SystemMouseCursors.click : null,
      recognizer: _tapGestureRecognizer,
      style: style.copyWith(
        overflow: widget.overflow,
        decoration: widget.link != null ? TextDecoration.underline : null,
        color: widget.link != null ? colors.primary : widget.color,
      ),
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
