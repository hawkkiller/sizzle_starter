import 'package:flutter/material.dart';

/// Semantic color tokens used across the UI system.
class UiColorTokens {
  /// Creates semantic color tokens.
  const UiColorTokens({
    required this.background,
    required this.surface,
    required this.surfaceRaised,
    required this.onSurface,
    required this.onSurfaceMuted,
    required this.outline,
    required this.focus,
    required this.primary,
    required this.onPrimary,
    required this.success,
    required this.onSuccess,
    required this.successContainer,
    required this.onSuccessContainer,
    required this.warning,
    required this.onWarning,
    required this.warningContainer,
    required this.onWarningContainer,
    required this.error,
    required this.onError,
    required this.errorContainer,
    required this.onErrorContainer,
    required this.info,
    required this.onInfo,
    required this.infoContainer,
    required this.onInfoContainer,
    required this.scrim,
  });

  /// Root app/page background color.
  final Color background;

  /// Default component surface color.
  final Color surface;

  /// Elevated component surface color.
  final Color surfaceRaised;

  /// Primary foreground color on surface/background.
  final Color onSurface;

  /// Secondary foreground color on surface/background.
  final Color onSurfaceMuted;

  /// Default border/divider color.
  final Color outline;

  /// Focus ring color.
  final Color focus;

  /// Main interactive accent color.
  final Color primary;

  /// Foreground color on [primary].
  final Color onPrimary;

  /// Success color.
  final Color success;

  /// Foreground color on [success].
  final Color onSuccess;

  /// Success background/container color.
  final Color successContainer;

  /// Foreground color on [successContainer].
  final Color onSuccessContainer;

  /// Warning color.
  final Color warning;

  /// Foreground color on [warning].
  final Color onWarning;

  /// Warning background/container color.
  final Color warningContainer;

  /// Foreground color on [warningContainer].
  final Color onWarningContainer;

  /// Error color.
  final Color error;

  /// Foreground color on [error].
  final Color onError;

  /// Error background/container color.
  final Color errorContainer;

  /// Foreground color on [errorContainer].
  final Color onErrorContainer;

  /// Info color.
  final Color info;

  /// Foreground color on [info].
  final Color onInfo;

  /// Info background/container color.
  final Color infoContainer;

  /// Foreground color on [infoContainer].
  final Color onInfoContainer;

  /// Overlay scrim color.
  final Color scrim;

  /// Creates a copy with selected overrides.
  UiColorTokens copyWith({
    Color? background,
    Color? surface,
    Color? surfaceRaised,
    Color? onSurface,
    Color? onSurfaceMuted,
    Color? outline,
    Color? focus,
    Color? primary,
    Color? onPrimary,
    Color? success,
    Color? onSuccess,
    Color? successContainer,
    Color? onSuccessContainer,
    Color? warning,
    Color? onWarning,
    Color? warningContainer,
    Color? onWarningContainer,
    Color? error,
    Color? onError,
    Color? errorContainer,
    Color? onErrorContainer,
    Color? info,
    Color? onInfo,
    Color? infoContainer,
    Color? onInfoContainer,
    Color? scrim,
  }) {
    return UiColorTokens(
      background: background ?? this.background,
      surface: surface ?? this.surface,
      surfaceRaised: surfaceRaised ?? this.surfaceRaised,
      onSurface: onSurface ?? this.onSurface,
      onSurfaceMuted: onSurfaceMuted ?? this.onSurfaceMuted,
      outline: outline ?? this.outline,
      focus: focus ?? this.focus,
      primary: primary ?? this.primary,
      onPrimary: onPrimary ?? this.onPrimary,
      success: success ?? this.success,
      onSuccess: onSuccess ?? this.onSuccess,
      successContainer: successContainer ?? this.successContainer,
      onSuccessContainer: onSuccessContainer ?? this.onSuccessContainer,
      warning: warning ?? this.warning,
      onWarning: onWarning ?? this.onWarning,
      warningContainer: warningContainer ?? this.warningContainer,
      onWarningContainer: onWarningContainer ?? this.onWarningContainer,
      error: error ?? this.error,
      onError: onError ?? this.onError,
      errorContainer: errorContainer ?? this.errorContainer,
      onErrorContainer: onErrorContainer ?? this.onErrorContainer,
      info: info ?? this.info,
      onInfo: onInfo ?? this.onInfo,
      infoContainer: infoContainer ?? this.infoContainer,
      onInfoContainer: onInfoContainer ?? this.onInfoContainer,
      scrim: scrim ?? this.scrim,
    );
  }

  /// Linearly interpolates this token set with another one.
  UiColorTokens lerp(UiColorTokens other, double t) {
    return UiColorTokens(
      background: Color.lerp(background, other.background, t) ?? background,
      surface: Color.lerp(surface, other.surface, t) ?? surface,
      surfaceRaised: Color.lerp(surfaceRaised, other.surfaceRaised, t) ?? surfaceRaised,
      onSurface: Color.lerp(onSurface, other.onSurface, t) ?? onSurface,
      onSurfaceMuted: Color.lerp(onSurfaceMuted, other.onSurfaceMuted, t) ?? onSurfaceMuted,
      outline: Color.lerp(outline, other.outline, t) ?? outline,
      focus: Color.lerp(focus, other.focus, t) ?? focus,
      primary: Color.lerp(primary, other.primary, t) ?? primary,
      onPrimary: Color.lerp(onPrimary, other.onPrimary, t) ?? onPrimary,
      success: Color.lerp(success, other.success, t) ?? success,
      onSuccess: Color.lerp(onSuccess, other.onSuccess, t) ?? onSuccess,
      successContainer: Color.lerp(successContainer, other.successContainer, t) ?? successContainer,
      onSuccessContainer:
          Color.lerp(onSuccessContainer, other.onSuccessContainer, t) ?? onSuccessContainer,
      warning: Color.lerp(warning, other.warning, t) ?? warning,
      onWarning: Color.lerp(onWarning, other.onWarning, t) ?? onWarning,
      warningContainer: Color.lerp(warningContainer, other.warningContainer, t) ?? warningContainer,
      onWarningContainer:
          Color.lerp(onWarningContainer, other.onWarningContainer, t) ?? onWarningContainer,
      error: Color.lerp(error, other.error, t) ?? error,
      onError: Color.lerp(onError, other.onError, t) ?? onError,
      errorContainer: Color.lerp(errorContainer, other.errorContainer, t) ?? errorContainer,
      onErrorContainer: Color.lerp(onErrorContainer, other.onErrorContainer, t) ?? onErrorContainer,
      info: Color.lerp(info, other.info, t) ?? info,
      onInfo: Color.lerp(onInfo, other.onInfo, t) ?? onInfo,
      infoContainer: Color.lerp(infoContainer, other.infoContainer, t) ?? infoContainer,
      onInfoContainer: Color.lerp(onInfoContainer, other.onInfoContainer, t) ?? onInfoContainer,
      scrim: Color.lerp(scrim, other.scrim, t) ?? scrim,
    );
  }
}
