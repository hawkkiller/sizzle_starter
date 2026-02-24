import 'dart:ui' show lerpDouble;

/// Semantic radius tokens used by component categories.
class UiRadiusTokens {
  /// Creates semantic radius tokens.
  const UiRadiusTokens({
    required this.none,
    required this.component,
    required this.container,
    required this.dialog,
    required this.full,
  });

  /// Radius for sharp corners.
  final double none;

  /// Radius for controls such as buttons and inputs.
  final double component;

  /// Radius for cards and panel-like surfaces.
  final double container;

  /// Radius for dialogs and sheets.
  final double dialog;

  /// Radius for fully rounded/pill corners.
  final double full;

  /// Creates a copy with selected overrides.
  UiRadiusTokens copyWith({
    double? none,
    double? interactive,
    double? container,
    double? dialog,
    double? full,
  }) {
    return UiRadiusTokens(
      none: none ?? this.none,
      component: interactive ?? this.component,
      container: container ?? this.container,
      dialog: dialog ?? this.dialog,
      full: full ?? this.full,
    );
  }

  /// Linearly interpolates this token set with another one.
  UiRadiusTokens lerp(UiRadiusTokens other, double t) {
    return UiRadiusTokens(
      none: lerpDouble(none, other.none, t) ?? none,
      component: lerpDouble(component, other.component, t) ?? component,
      container: lerpDouble(container, other.container, t) ?? container,
      dialog: lerpDouble(dialog, other.dialog, t) ?? dialog,
      full: lerpDouble(full, other.full, t) ?? full,
    );
  }
}
