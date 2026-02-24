import 'package:common_ui/common_ui.dart';
import 'package:flutter/material.dart';

/// A nature-inspired theme evoking Nordic fjord waters and mossy landscapes.
///
/// Uses warm blue as the primary accent (deep fjord water) with warm gray
/// neutrals for an organic, earthy feel.
class FjordMossTheme extends UiTheme {
  /// Creates a Fjord Moss theme instance.
  FjordMossTheme()
    : super(
        brightness: Brightness.light,
        color: UiColorTokens(
          background: uiWarmGray.shade50,
          surface: uiWarmGray.shade100,
          surfaceRaised: const Color(0xFFFFFFFF),
          onSurface: uiWarmGray.shade900,
          onSurfaceMuted: uiWarmGray.shade600,
          outline: uiWarmGray.shade300,
          focus: uiWarmBlue.shade500,
          primary: uiWarmBlue.shade500,
          onPrimary: const Color(0xFFFFFFFF),
          success: uiGreen.shade600,
          onSuccess: const Color(0xFFFFFFFF),
          successContainer: uiGreen.shade100,
          onSuccessContainer: uiGreen.shade600,
          warning: uiAmber.shade600,
          onWarning: const Color(0xFFFFFFFF),
          warningContainer: uiAmber.shade100,
          onWarningContainer: uiAmber.shade600,
          error: uiRed.shade600,
          onError: const Color(0xFFFFFFFF),
          errorContainer: uiRed.shade100,
          onErrorContainer: uiRed.shade800,
          info: uiBlue.shade600,
          onInfo: const Color(0xFFFFFFFF),
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
          interactive: 9999,
          container: 12,
          dialog: 16,
          full: 9999,
        ),
        borderWidth: const UiBorderWidthTokens(
          none: 0,
          hairline: 0.5,
          subtle: 1,
          strong: 2,
          focus: 2,
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
        component: const UiComponentThemes(),
      );
}
