import 'package:common_ui/common_ui.dart';
import 'package:flutter/material.dart';

export 'themes/sandgold_theme.dart';

/// Aggregated design theme used by UI components.
class UiTheme extends ThemeExtension<UiTheme> {
  /// Creates a full theme.
  const UiTheme({
    required this.color,
    required this.brightness,
    required this.typography,
    required this.spacing,
    required this.radius,
    required this.borderWidth,
    required this.opacity,
    required this.elevation,
  });

  /// Retrieves the [UiTheme] from the nearest [Theme] ancestor.
  static UiTheme of(BuildContext context) {
    final theme = Theme.of(context).extension<UiTheme>();
    return theme ?? SandgoldTheme();
  }

  /// Builds a [ThemeData] from the theme.
  ThemeData buildThemeData() {
    return ThemeData(
      brightness: brightness,
      extensions: [this],
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: color.focus,
        selectionColor: color.focus.withValues(alpha: opacity.focus),
        selectionHandleColor: color.focus,
      ),
    );
  }

  /// Semantic color tokens.
  final UiColorTokens color;

  /// Brightness of the theme.
  final Brightness brightness;

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
    Brightness? brightness,
  }) {
    return UiTheme(
      color: color ?? this.color,
      typography: typography ?? this.typography,
      spacing: spacing ?? this.spacing,
      radius: radius ?? this.radius,
      borderWidth: borderWidth ?? this.borderWidth,
      opacity: opacity ?? this.opacity,
      elevation: elevation ?? this.elevation,
      brightness: brightness ?? this.brightness,
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
      brightness: other.brightness,
    );
  }
}
