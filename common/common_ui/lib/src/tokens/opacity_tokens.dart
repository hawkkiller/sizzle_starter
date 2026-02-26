import 'dart:ui' show lerpDouble;

/// Semantic opacity tokens for interaction states and overlays.
class UiOpacityTokens {
  /// Creates semantic opacity tokens.
  const UiOpacityTokens({
    required this.disabled,
    required this.hover,
    required this.pressed,
    required this.dragged,
    required this.focus,
    required this.scrim,
  });

  /// Opacity for disabled content/components.
  final double disabled;

  /// Opacity for hover overlays.
  final double hover;

  /// Opacity for pressed-state overlays.
  final double pressed;

  /// Opacity for dragged/active overlays.
  final double dragged;

  /// Opacity for focus overlays.
  final double focus;

  /// Opacity for modal backdrop dimming.
  final double scrim;

  /// Creates a copy with selected overrides.
  UiOpacityTokens copyWith({
    double? disabled,
    double? hover,
    double? pressed,
    double? dragged,
    double? focus,
    double? scrim,
  }) {
    return UiOpacityTokens(
      disabled: disabled ?? this.disabled,
      hover: hover ?? this.hover,
      pressed: pressed ?? this.pressed,
      dragged: dragged ?? this.dragged,
      focus: focus ?? this.focus,
      scrim: scrim ?? this.scrim,
    );
  }

  /// Linearly interpolates this token set with another one.
  UiOpacityTokens lerp(UiOpacityTokens other, double t) {
    return UiOpacityTokens(
      disabled: lerpDouble(disabled, other.disabled, t) ?? disabled,
      hover: lerpDouble(hover, other.hover, t) ?? hover,
      pressed: lerpDouble(pressed, other.pressed, t) ?? pressed,
      dragged: lerpDouble(dragged, other.dragged, t) ?? dragged,
      focus: lerpDouble(focus, other.focus, t) ?? focus,
      scrim: lerpDouble(scrim, other.scrim, t) ?? scrim,
    );
  }
}
