import 'package:common_ui/common_ui.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

/// A themed text widget that maps semantic size presets to the design system typography.
class UiText extends StatefulWidget {
  // dart format off
  const UiText.displayLarge(String this.text, {super.key, this.color, this.textAlign = TextAlign.start, this.overflow = TextOverflow.ellipsis, this.maxLines, this.selectable = false, this.emphasized = false, this.onTap}) : type = UiTypographySize.displayLarge, span = null;
  const UiText.displayMedium(String this.text, {super.key, this.color, this.textAlign = TextAlign.start, this.overflow = TextOverflow.ellipsis, this.maxLines, this.selectable = false, this.emphasized = false, this.onTap}) : type = UiTypographySize.displayMedium, span = null;
  const UiText.displaySmall(String this.text, {super.key, this.color, this.textAlign = TextAlign.start, this.overflow = TextOverflow.ellipsis, this.maxLines, this.selectable = false, this.emphasized = false, this.onTap}) : type = UiTypographySize.displaySmall, span = null;
  const UiText.headlineLarge(String this.text, {super.key, this.color, this.textAlign = TextAlign.start, this.overflow = TextOverflow.ellipsis, this.maxLines, this.selectable = false, this.emphasized = false, this.onTap}) : type = UiTypographySize.headlineLarge, span = null;
  const UiText.headlineMedium(String this.text, {super.key, this.color, this.textAlign = TextAlign.start, this.overflow = TextOverflow.ellipsis, this.maxLines, this.selectable = false, this.emphasized = false, this.onTap}) : type = UiTypographySize.headlineMedium, span = null;
  const UiText.headlineSmall(String this.text, {super.key, this.color, this.textAlign = TextAlign.start, this.overflow = TextOverflow.ellipsis, this.maxLines, this.selectable = false, this.emphasized = false, this.onTap}) : type = UiTypographySize.headlineSmall, span = null;
  const UiText.titleLarge(String this.text, {super.key, this.color, this.textAlign = TextAlign.start, this.overflow = TextOverflow.ellipsis, this.maxLines, this.selectable = false, this.emphasized = false, this.onTap}) : type = UiTypographySize.titleLarge, span = null;
  const UiText.titleMedium(String this.text, {super.key, this.color, this.textAlign = TextAlign.start, this.overflow = TextOverflow.ellipsis, this.maxLines, this.selectable = false, this.emphasized = false, this.onTap}) : type = UiTypographySize.titleMedium, span = null;
  const UiText.titleSmall(String this.text, {super.key, this.color, this.textAlign = TextAlign.start, this.overflow = TextOverflow.ellipsis, this.maxLines, this.selectable = false, this.emphasized = false, this.onTap}) : type = UiTypographySize.titleSmall, span = null;
  const UiText.bodyLarge(String this.text, {super.key, this.color, this.textAlign = TextAlign.start, this.overflow = TextOverflow.ellipsis, this.maxLines, this.selectable = false, this.emphasized = false, this.onTap}) : type = UiTypographySize.bodyLarge, span = null;
  const UiText.bodyMedium(String this.text, {super.key, this.color, this.textAlign = TextAlign.start, this.overflow = TextOverflow.ellipsis, this.maxLines, this.selectable = false, this.emphasized = false, this.onTap}) : type = UiTypographySize.bodyMedium, span = null;
  const UiText.bodySmall(String this.text, {super.key, this.color, this.textAlign = TextAlign.start, this.overflow = TextOverflow.ellipsis, this.maxLines, this.selectable = false, this.emphasized = false, this.onTap}) : type = UiTypographySize.bodySmall, span = null;
  const UiText.labelLarge(String this.text, {super.key, this.color, this.textAlign = TextAlign.start, this.overflow = TextOverflow.ellipsis, this.maxLines, this.selectable = false, this.emphasized = false, this.onTap}) : type = UiTypographySize.labelLarge, span = null;
  const UiText.labelMedium(String this.text, {super.key, this.color, this.textAlign = TextAlign.start, this.overflow = TextOverflow.ellipsis, this.maxLines, this.selectable = false, this.emphasized = false, this.onTap}) : type = UiTypographySize.labelMedium, span = null;
  const UiText.labelSmall(String this.text, {super.key, this.color, this.textAlign = TextAlign.start, this.overflow = TextOverflow.ellipsis, this.maxLines, this.selectable = false, this.emphasized = false, this.onTap}) : type = UiTypographySize.labelSmall, span = null;

  /// Creates themed text from a rich span tree.
  const UiText.rich({
    required InlineSpan this.span,
    required this.type,
    super.key,
    this.color,
    this.textAlign = TextAlign.start,
    this.overflow = TextOverflow.ellipsis,
    this.maxLines,
    this.selectable = false,
    this.emphasized = false,
    this.onTap,
  }) : text = null;

  /// Creates themed text from localized semantic markup.
  factory UiText.markup(
    String markup, {
    required UiTypographySize type,
    Key? key,
    Color? color,
    TextAlign textAlign = TextAlign.start,
    TextOverflow? overflow = TextOverflow.ellipsis,
    int? maxLines,
    bool selectable = false,
    bool emphasized = false,
    VoidCallback? onTap,
    Map<String, UiTextMarkupBuilder> builders = const {},
  }) {
    return UiText.rich(
      key: key,
      type: type,
      color: color,
      textAlign: textAlign,
      overflow: overflow,
      maxLines: maxLines,
      selectable: selectable,
      emphasized: emphasized,
      onTap: onTap,
      span: UiTextMarkup.parse(markup, builders: builders),
    );
  }
  // dart format on

  /// The text content to display.
  final String? text;

  /// The rich content to display.
  final InlineSpan? span;

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
    final baseStyle = typography.getTextStyle(widget.type);
    final resolvedStyle = baseStyle.copyWith(
      color: widget.color ?? (_isLink ? colors.primary : colors.onSurface),
      fontWeight: widget.emphasized ? FontWeight.w600 : null,
      overflow: widget.overflow,
      decoration: _isLink ? TextDecoration.underline : null,
    );

    final span = TextSpan(
      mouseCursor: widget.onTap != null ? SystemMouseCursors.click : null,
      recognizer: _tapGestureRecognizer,
      style: resolvedStyle,
      children: [
        widget.span ?? TextSpan(text: widget.text),
      ],
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

/// Builds a styled span for a parsed text markup tag.
typedef UiTextMarkupBuilder = InlineSpan Function(UiTextMarkupTag tag);

/// A parsed semantic tag from localized rich text markup.
class UiTextMarkupTag {
  /// Creates a parsed semantic tag.
  const UiTextMarkupTag({
    required this.name,
    required this.children,
  });

  /// The semantic tag name.
  final String name;

  /// The child spans parsed inside the tag.
  final List<InlineSpan> children;
}

/// Parses simple XML-like markup into themed text spans.
abstract final class UiTextMarkup {
  /// Parses a localized message that contains semantic tags like `<time>...</time>`.
  static TextSpan parse(
    String markup, {
    Map<String, UiTextMarkupBuilder> builders = const {},
  }) {
    final root = _UiTextMarkupTagNode.root();
    final stack = <_UiTextMarkupTagNode>[root];
    final tagPattern = RegExp(r'<(/?)([a-zA-Z][\w-]*)>');
    var cursor = 0;

    for (final match in tagPattern.allMatches(markup)) {
      if (match.start > cursor) {
        stack.last.children.add(_UiTextMarkupTextNode(markup.substring(cursor, match.start)));
      }

      final isClosingTag = match.group(1) == '/';
      final tagName = match.group(2)!;

      if (isClosingTag) {
        if (stack.length == 1 || stack.last.name != tagName) {
          return TextSpan(text: markup);
        }

        stack.removeLast();
      } else {
        final tag = _UiTextMarkupTagNode(tagName);
        stack.last.children.add(tag);
        stack.add(tag);
      }

      cursor = match.end;
    }

    if (cursor < markup.length) {
      stack.last.children.add(_UiTextMarkupTextNode(markup.substring(cursor)));
    }

    if (stack.length != 1) {
      return TextSpan(text: markup);
    }

    return TextSpan(children: root.buildChildren(builders));
  }
}

sealed class _UiTextMarkupNode {
  InlineSpan build(Map<String, UiTextMarkupBuilder> builders);
}

class _UiTextMarkupTextNode extends _UiTextMarkupNode {
  _UiTextMarkupTextNode(this.text);

  final String text;

  @override
  InlineSpan build(Map<String, UiTextMarkupBuilder> builders) => TextSpan(text: text);
}

class _UiTextMarkupTagNode extends _UiTextMarkupNode {
  _UiTextMarkupTagNode(this.name);

  _UiTextMarkupTagNode.root() : name = null;

  final String? name;
  final List<_UiTextMarkupNode> children = <_UiTextMarkupNode>[];

  List<InlineSpan> buildChildren(Map<String, UiTextMarkupBuilder> builders) {
    return children.map((child) => child.build(builders)).toList(growable: false);
  }

  @override
  InlineSpan build(Map<String, UiTextMarkupBuilder> builders) {
    final builtChildren = buildChildren(builders);
    final name = this.name;

    if (name == null) return TextSpan(children: builtChildren);

    final builder = builders[name];
    if (builder == null) return TextSpan(children: builtChildren);

    return _UiTextMarkupInteractionExpander.expand(
      builder(UiTextMarkupTag(name: name, children: builtChildren)),
    );
  }
}

abstract final class _UiTextMarkupInteractionExpander {
  static InlineSpan expand(InlineSpan span) {
    return _expand(span, inherited: null);
  }

  static InlineSpan _expand(
    InlineSpan span, {
    required _UiTextMarkupInteraction? inherited,
  }) {
    if (span is! TextSpan) {
      return span;
    }

    final interaction = _UiTextMarkupInteraction.resolve(
      span,
      inherited: inherited,
    );

    return TextSpan(
      text: span.text,
      style: span.style,
      recognizer: interaction.recognizer,
      mouseCursor: interaction.explicitMouseCursor,
      onEnter: interaction.onEnter,
      onExit: interaction.onExit,
      semanticsLabel: span.semanticsLabel,
      semanticsIdentifier: span.semanticsIdentifier,
      locale: span.locale,
      spellOut: span.spellOut,
      children: span.children
          ?.map((child) => _expand(child, inherited: interaction))
          .toList(growable: false),
    );
  }
}

class _UiTextMarkupInteraction {
  const _UiTextMarkupInteraction({
    required this.recognizer,
    required this.explicitMouseCursor,
    required this.onEnter,
    required this.onExit,
  });

  factory _UiTextMarkupInteraction.resolve(
    TextSpan span, {
    required _UiTextMarkupInteraction? inherited,
  }) {
    final hasOwnRecognizer = span.recognizer != null;
    final hasOwnMouseCursor = span.mouseCursor != MouseCursor.defer;

    return _UiTextMarkupInteraction(
      recognizer: span.recognizer ?? inherited?.recognizer,
      explicitMouseCursor: hasOwnRecognizer
          ? _explicitMouseCursorForRecognizer(span.mouseCursor)
          : hasOwnMouseCursor
          ? span.mouseCursor
          : inherited?.explicitMouseCursor,
      onEnter: span.onEnter ?? inherited?.onEnter,
      onExit: span.onExit ?? inherited?.onExit,
    );
  }

  final GestureRecognizer? recognizer;
  final MouseCursor? explicitMouseCursor;
  final void Function(PointerEnterEvent event)? onEnter;
  final void Function(PointerExitEvent event)? onExit;

  static MouseCursor? _explicitMouseCursorForRecognizer(MouseCursor mouseCursor) {
    return mouseCursor == SystemMouseCursors.click ? null : mouseCursor;
  }
}
