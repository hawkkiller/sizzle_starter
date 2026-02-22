import 'package:flutter/material.dart';

/// Semantic typography tokens based on a material-inspired 15-role scale.
class UiTypographyTokens {
  /// Creates semantic typography tokens.
  const UiTypographyTokens({
    required this.displayLarge,
    required this.displayMedium,
    required this.displaySmall,
    required this.headlineLarge,
    required this.headlineMedium,
    required this.headlineSmall,
    required this.titleLarge,
    required this.titleMedium,
    required this.titleSmall,
    required this.bodyLarge,
    required this.bodyMedium,
    required this.bodySmall,
    required this.labelLarge,
    required this.labelMedium,
    required this.labelSmall,
  });

  /// Largest hero/prominent display style.
  final TextStyle displayLarge;

  /// Medium display style.
  final TextStyle displayMedium;

  /// Small display style.
  final TextStyle displaySmall;

  /// Largest headline style.
  final TextStyle headlineLarge;

  /// Medium headline style.
  final TextStyle headlineMedium;

  /// Small headline style.
  final TextStyle headlineSmall;

  /// Largest title style.
  final TextStyle titleLarge;

  /// Medium title style.
  final TextStyle titleMedium;

  /// Small title style.
  final TextStyle titleSmall;

  /// Largest body text style.
  final TextStyle bodyLarge;

  /// Default body text style.
  final TextStyle bodyMedium;

  /// Small body text style.
  final TextStyle bodySmall;

  /// Largest label style.
  final TextStyle labelLarge;

  /// Medium label style.
  final TextStyle labelMedium;

  /// Small label style.
  final TextStyle labelSmall;

  /// Creates a copy with selected overrides.
  UiTypographyTokens copyWith({
    TextStyle? displayLarge,
    TextStyle? displayMedium,
    TextStyle? displaySmall,
    TextStyle? headlineLarge,
    TextStyle? headlineMedium,
    TextStyle? headlineSmall,
    TextStyle? titleLarge,
    TextStyle? titleMedium,
    TextStyle? titleSmall,
    TextStyle? bodyLarge,
    TextStyle? bodyMedium,
    TextStyle? bodySmall,
    TextStyle? labelLarge,
    TextStyle? labelMedium,
    TextStyle? labelSmall,
  }) {
    return UiTypographyTokens(
      displayLarge: displayLarge ?? this.displayLarge,
      displayMedium: displayMedium ?? this.displayMedium,
      displaySmall: displaySmall ?? this.displaySmall,
      headlineLarge: headlineLarge ?? this.headlineLarge,
      headlineMedium: headlineMedium ?? this.headlineMedium,
      headlineSmall: headlineSmall ?? this.headlineSmall,
      titleLarge: titleLarge ?? this.titleLarge,
      titleMedium: titleMedium ?? this.titleMedium,
      titleSmall: titleSmall ?? this.titleSmall,
      bodyLarge: bodyLarge ?? this.bodyLarge,
      bodyMedium: bodyMedium ?? this.bodyMedium,
      bodySmall: bodySmall ?? this.bodySmall,
      labelLarge: labelLarge ?? this.labelLarge,
      labelMedium: labelMedium ?? this.labelMedium,
      labelSmall: labelSmall ?? this.labelSmall,
    );
  }

  /// Linearly interpolates this token set with another one.
  UiTypographyTokens lerp(UiTypographyTokens other, double t) {
    return UiTypographyTokens(
      displayLarge: TextStyle.lerp(displayLarge, other.displayLarge, t) ?? displayLarge,
      displayMedium: TextStyle.lerp(displayMedium, other.displayMedium, t) ?? displayMedium,
      displaySmall: TextStyle.lerp(displaySmall, other.displaySmall, t) ?? displaySmall,
      headlineLarge: TextStyle.lerp(headlineLarge, other.headlineLarge, t) ?? headlineLarge,
      headlineMedium: TextStyle.lerp(headlineMedium, other.headlineMedium, t) ?? headlineMedium,
      headlineSmall: TextStyle.lerp(headlineSmall, other.headlineSmall, t) ?? headlineSmall,
      titleLarge: TextStyle.lerp(titleLarge, other.titleLarge, t) ?? titleLarge,
      titleMedium: TextStyle.lerp(titleMedium, other.titleMedium, t) ?? titleMedium,
      titleSmall: TextStyle.lerp(titleSmall, other.titleSmall, t) ?? titleSmall,
      bodyLarge: TextStyle.lerp(bodyLarge, other.bodyLarge, t) ?? bodyLarge,
      bodyMedium: TextStyle.lerp(bodyMedium, other.bodyMedium, t) ?? bodyMedium,
      bodySmall: TextStyle.lerp(bodySmall, other.bodySmall, t) ?? bodySmall,
      labelLarge: TextStyle.lerp(labelLarge, other.labelLarge, t) ?? labelLarge,
      labelMedium: TextStyle.lerp(labelMedium, other.labelMedium, t) ?? labelMedium,
      labelSmall: TextStyle.lerp(labelSmall, other.labelSmall, t) ?? labelSmall,
    );
  }
}
