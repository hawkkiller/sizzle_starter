import 'package:common_ui/src/tokens/border_width_tokens.dart';
import 'package:common_ui/src/tokens/color_tokens.dart';
import 'package:common_ui/src/tokens/elevation_tokens.dart';
import 'package:common_ui/src/tokens/opacity_tokens.dart';
import 'package:common_ui/src/tokens/radius_tokens.dart';
import 'package:common_ui/src/tokens/spacing_tokens.dart';
import 'package:common_ui/src/tokens/typography_tokens.dart';
import 'package:flutter/material.dart';

/// Aggregated design theme used by UI components.
class UiTheme extends ThemeExtension<UiTheme> {
  /// Creates a full theme.
  const UiTheme({
    required this.color,
    required this.typography,
    required this.spacing,
    required this.radius,
    required this.borderWidth,
    required this.opacity,
    required this.elevation,
  });

  /// Semantic color tokens.
  final UiColorTokens color;

  /// Semantic typography tokens.
  final UiTypographyTokens typography;

  /// Semantic spacing tokens.
  final UiSpacing spacing;

  /// Semantic radius tokens.
  final UiRadiusTokens radius;

  /// Semantic border width tokens.
  final UiBorderWidthTokens borderWidth;

  /// Semantic opacity tokens.
  final UiOpacityTokens opacity;

  /// Semantic elevation tokens.
  final UiElevationTokens elevation;

  @override
  UiTheme copyWith({
    UiColorTokens? color,
    UiTypographyTokens? typography,
    UiSpacing? spacing,
    UiRadiusTokens? radius,
    UiBorderWidthTokens? borderWidth,
    UiOpacityTokens? opacity,
    UiElevationTokens? elevation,
  }) {
    return UiTheme(
      color: color ?? this.color,
      typography: typography ?? this.typography,
      spacing: spacing ?? this.spacing,
      radius: radius ?? this.radius,
      borderWidth: borderWidth ?? this.borderWidth,
      opacity: opacity ?? this.opacity,
      elevation: elevation ?? this.elevation,
    );
  }

  @override
  UiTheme lerp(covariant ThemeExtension<UiTheme>? other, double t) {
    if (other is! UiTheme) {
      return this;
    }

    return UiTheme(
      color: color.lerp(other.color, t),
      typography: typography.lerp(other.typography, t),
      spacing: spacing.lerp(other.spacing, t),
      radius: radius.lerp(other.radius, t),
      borderWidth: borderWidth.lerp(other.borderWidth, t),
      opacity: opacity.lerp(other.opacity, t),
      elevation: elevation.lerp(other.elevation, t),
    );
  }
}
