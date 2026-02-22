import 'dart:ui' show lerpDouble;

/// Semantic border width tokens for UI boundaries and focus rings.
class UiBorderWidthTokens {
  /// Creates semantic border width tokens.
  const UiBorderWidthTokens({
    required this.none,
    required this.hairline,
    required this.subtle,
    required this.strong,
    required this.focus,
  });

  /// Width for no border.
  final double none;

  /// Width for separators and thin dividers.
  final double hairline;

  /// Width for default low-emphasis borders.
  final double subtle;

  /// Width for emphasized borders.
  final double strong;

  /// Width for focus outline/ring borders.
  final double focus;

  /// Creates a copy with selected overrides.
  UiBorderWidthTokens copyWith({
    double? none,
    double? hairline,
    double? subtle,
    double? strong,
    double? focus,
  }) {
    return UiBorderWidthTokens(
      none: none ?? this.none,
      hairline: hairline ?? this.hairline,
      subtle: subtle ?? this.subtle,
      strong: strong ?? this.strong,
      focus: focus ?? this.focus,
    );
  }

  /// Linearly interpolates this token set with another one.
  UiBorderWidthTokens lerp(UiBorderWidthTokens other, double t) {
    return UiBorderWidthTokens(
      none: lerpDouble(none, other.none, t) ?? none,
      hairline: lerpDouble(hairline, other.hairline, t) ?? hairline,
      subtle: lerpDouble(subtle, other.subtle, t) ?? subtle,
      strong: lerpDouble(strong, other.strong, t) ?? strong,
      focus: lerpDouble(focus, other.focus, t) ?? focus,
    );
  }
}
