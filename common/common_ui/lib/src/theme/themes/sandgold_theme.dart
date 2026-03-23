import 'package:common_ui/common_ui.dart';
import 'package:flutter/material.dart';

/// A warm light theme with sandy golden undertones.
///
/// Uses warm blue as the primary accent with warm gray neutrals
/// for an organic, inviting feel.
class SandgoldTheme extends UiTheme {
  /// Creates a Sandgold theme instance.
  SandgoldTheme()
    : super(
        brightness: Brightness.light,
        color: UiColorTokens(
          background: uiWarmGray.shade50,
          surface: uiWarmGray.shade75,
          surfaceInteractive: uiWarmGray.shade100,
          surfaceRaised: uiWhite,
          surfaceInverse: uiWarmGray.shade900,
          onSurface: uiWarmGray.shade900,
          onSurfaceInverse: uiWarmGray.shade50,
          onSurfaceMuted: uiWarmGray.shade600,
          outline: uiWarmGray.shade300,
          focus: uiRust.shade400,
          primary: uiRust.shade500,
          primaryContainer: uiRust.shade100,
          primaryInverse: uiRust.shade400,
          onPrimary: uiRust.shade25,
          onPrimaryContainer: uiRust.shade700,
          success: uiGreen.shade600,
          onSuccess: uiGreen.shade25,
          successContainer: uiGreen.shade100,
          onSuccessContainer: uiGreen.shade600,
          warning: uiOrange.shade600,
          onWarning: uiOrange.shade25,
          warningContainer: uiAmber.shade100,
          onWarningContainer: uiAmber.shade600,
          error: uiRed.shade600,
          onError: uiRed.shade25,
          errorContainer: uiRed.shade100,
          onErrorContainer: uiRed.shade600,
          info: uiBlue.shade600,
          onInfo: uiBlue.shade25,
          infoContainer: uiBlue.shade100,
          onInfoContainer: uiBlue.shade600,
          scrim: uiWarmGray.shade950,
        ),
        typography: const UiTypographyTokens(
          displayLarge: TextStyle(
            fontSize: 57,
            fontWeight: FontWeight.w400,
            height: 1.12,
            letterSpacing: -0.25,
          ),
          displayMedium: TextStyle(
            fontSize: 45,
            fontWeight: FontWeight.w400,
            height: 1.16,
          ),
          displaySmall: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.w400,
            height: 1.22,
          ),
          headlineLarge: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w600,
            height: 1.25,
          ),
          headlineMedium: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w600,
            height: 1.29,
          ),
          headlineSmall: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            height: 1.33,
          ),
          titleLarge: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w500,
            height: 1.27,
          ),
          titleMedium: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            height: 1.50,
            letterSpacing: 0.15,
          ),
          titleSmall: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            height: 1.43,
            letterSpacing: 0.1,
          ),
          bodyLarge: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            height: 1.50,
            letterSpacing: 0.5,
          ),
          bodyMedium: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            height: 1.43,
            letterSpacing: 0.25,
          ),
          bodySmall: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            height: 1.33,
            letterSpacing: 0.4,
          ),
          labelLarge: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            height: 1.43,
            letterSpacing: 0.1,
          ),
          labelMedium: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            height: 1.33,
            letterSpacing: 0.5,
          ),
          labelSmall: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            height: 1.45,
            letterSpacing: 0.5,
          ),
        ),
        spacing: const UiSpacing(),
        radius: const UiRadiusTokens(
          none: 0,
          component: 9999,
          container: 24,
          dialog: 16,
          full: 9999,
        ),
        borderWidth: const UiBorderWidthTokens(
          none: 0,
          hairline: 0.5,
          subtle: 1,
          strong: 2,
        ),
        opacity: const UiOpacityTokens(
          disabled: 0.38,
          hover: 0.08,
          pressed: 0.12,
          dragged: 0.16,
          focus: 0.12,
          scrim: 0.32,
        ),
        elevation: const UiElevationTokens(
          none: 0,
          raised: 1,
          floating: 3,
          overlay: 6,
          modal: 8,
        ),
      );
}
