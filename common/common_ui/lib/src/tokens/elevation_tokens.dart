import 'dart:ui' show lerpDouble;

/// Semantic elevation tokens that represent depth levels.
class UiElevationTokens {
  /// Creates semantic elevation tokens.
  const UiElevationTokens({
    required this.none,
    required this.raised,
    required this.floating,
    required this.overlay,
    required this.modal,
  });

  /// Flat depth with no elevation.
  final double none;

  /// Slightly lifted surface elevation.
  final double raised;

  /// Floating element elevation.
  final double floating;

  /// High-priority overlay elevation.
  final double overlay;

  /// Dialog/sheet modal elevation.
  final double modal;

  /// Creates a copy with selected overrides.
  UiElevationTokens copyWith({
    double? none,
    double? raised,
    double? floating,
    double? overlay,
    double? modal,
  }) {
    return UiElevationTokens(
      none: none ?? this.none,
      raised: raised ?? this.raised,
      floating: floating ?? this.floating,
      overlay: overlay ?? this.overlay,
      modal: modal ?? this.modal,
    );
  }

  /// Linearly interpolates this token set with another one.
  UiElevationTokens lerp(UiElevationTokens other, double t) {
    return UiElevationTokens(
      none: lerpDouble(none, other.none, t) ?? none,
      raised: lerpDouble(raised, other.raised, t) ?? raised,
      floating: lerpDouble(floating, other.floating, t) ?? floating,
      overlay: lerpDouble(overlay, other.overlay, t) ?? overlay,
      modal: lerpDouble(modal, other.modal, t) ?? modal,
    );
  }
}
