# Design System Tokens

Design tokens are semantic values for the design system. They are used to build scalable, consistent and extensible UI.

## Requirements

Here is a list of technical requirements to take into account when creating tokens:

- Tokens should be generic enough to support multiple brand styles. For example, one theme may use fully rounded controls (like text fields and buttons), while another uses slight or no rounding. But even in a fully rounded theme, not every component should be fully rounded; cards should keep standard rounded corners.
- Each token should include a recommended default use. For example, the background color token is for app backgrounds, not card backgrounds.
- Components should not use hardcoded visual values (color, radius, spacing, elevation, opacity).
- Token naming should be semantic and stable (avoid names tied to raw values like blue500 in app-facing APIs). The only exception right now is spacing tokens, which are named `sN` where `N` is the pixel value at default base. This makes it easier to understand the relationship between the token and the visual value and doesn't break customizations.

## Available Tokens

- Spacing
- Color
- Typography
- Breakpoints
- Radii
- Border Width
- Opacity
- Elevation

## V1 Token Contract

### Color (`UiColorTokens`)

- `background`
- `surface`
- `surfaceRaised`
- `onSurface`
- `onSurfaceMuted`
- `outline`
- `focus`
- `primary`
- `onPrimary`
- `success`
- `onSuccess`
- `successContainer`
- `onSuccessContainer`
- `warning`
- `onWarning`
- `warningContainer`
- `onWarningContainer`
- `error`
- `onError`
- `errorContainer`
- `onErrorContainer`
- `info`
- `onInfo`
- `infoContainer`
- `onInfoContainer`
- `scrim`

### Typography (`UiTypographyTokens`)

- `displayLarge`
- `displayMedium`
- `displaySmall`
- `headlineLarge`
- `headlineMedium`
- `headlineSmall`
- `titleLarge`
- `titleMedium`
- `titleSmall`
- `bodyLarge`
- `bodyMedium`
- `bodySmall`
- `labelLarge`
- `labelMedium`
- `labelSmall`

### Spacing (`UiSpacing`)

- `s4`, `s8`, `s12`, `s16`, `s24`, `s32`, `s48`, `s64`, `s96`, `s128`, `s192`, `s256`, `s384`, `s512`, `s640`, `s768`

### Radii (`UiRadiusTokens`)

- `none`
- `interactive`
- `container`
- `dialog`
- `full`

### Border Width (`UiBorderWidthTokens`)

- `none`
- `hairline`
- `subtle`
- `strong`
- `focus`

### Opacity (`UiOpacityTokens`)

- `disabled`
- `hover`
- `pressed`
- `dragged`
- `focus`
- `scrim`

### Elevation (`UiElevationTokens`)

- `none`
- `raised`
- `floating`
- `overlay`
- `modal`

V1 elevation tokens represent semantic depth values (`double`) only. A dedicated shadow-recipe system is out of scope for V1.

## Component Theme Layer

`UiComponentThemes` is a separate base `ThemeExtension` scaffold for future component-specific styling overrides.

V1 includes only this base scaffold and no component-specific theme models yet.
