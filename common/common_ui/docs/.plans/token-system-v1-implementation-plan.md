# Token System V1 for `common_ui` (Foundation Only)

## Summary
Deliver a scalable design-token foundation in `common/common_ui` with stable semantic APIs for `Color`, `Typography`, `Spacing`, `Radii`, `Border Width`, `Opacity`, and `Elevation`.
Include a separate component-theme layer for future per-component styling divergence without expanding global token semantics.
This plan intentionally excludes app adoption, migration, and test implementation work.

## Canonical Token Contract (Exact Slots)

### `UiColorTokens` exact slots (material-inspired semantics, DS-owned names)
- `background` - Root app/page background.
- `surface` - Default component surface (cards, inputs, tiles).
- `surfaceRaised` - Elevated surfaces (menus, raised cards).
- `onSurface` - Primary readable text/icons on surface/background.
- `onSurfaceMuted` - Secondary metadata/supporting text/icons.
- `outline` - Standard component borders.
- `focus` - Focus ring/border color.
- `primary` - Main interactive brand/action color.
- `onPrimary` - Text/icon on `primary` backgrounds.
- `success` - Success semantic color.
- `onSuccess` - Text/icon on success backgrounds.
- `successContainer` - Success-tinted background/container.
- `onSuccessContainer` - Text/icon on `successContainer`.
- `warning` - Warning semantic color.
- `onWarning` - Text/icon on warning backgrounds.
- `warningContainer` - Warning-tinted background/container.
- `onWarningContainer` - Text/icon on `warningContainer`.
- `error` - Error semantic color.
- `onError` - Text/icon on error backgrounds.
- `errorContainer` - Error-tinted background/container.
- `onErrorContainer` - Text/icon on `errorContainer`.
- `info` - Informational semantic color.
- `onInfo` - Text/icon on info backgrounds.
- `infoContainer` - Info-tinted background/container.
- `onInfoContainer` - Text/icon on `infoContainer`.
- `scrim` - Modal/backdrop dimming color.
 
### `UiTypographyTokens` exact slots
- `displayLarge` - Largest hero/prominent display text.
- `displayMedium` - Medium display text.
- `displaySmall` - Small display text.
- `headlineLarge` - Largest section/page headline.
- `headlineMedium` - Medium section/page headline.
- `headlineSmall` - Small section/page headline.
- `titleLarge` - Largest title style.
- `titleMedium` - Medium title style.
- `titleSmall` - Small title style.
- `bodyLarge` - Largest body copy style.
- `bodyMedium` - Default body copy style.
- `bodySmall` - Supporting small body copy.
- `labelLarge` - Largest label style for controls.
- `labelMedium` - Default label style for controls.
- `labelSmall` - Compact label/metadata style.

### `UiSpacing` exact slots (keep existing naming)
- `s4`, `s8`, `s12`, `s16`, `s24`, `s32`, `s48`, `s64`, `s96`, `s128`, `s192`, `s256`, `s384`, `s512`, `s640`, `s768`.

### `UiRadiusTokens` exact slots
- `none` - Sharp corners.
- `interactive` - Default for buttons/inputs/selectable controls.
- `container` - Default for cards/panels/surfaces.
- `dialog` - Default for dialogs/sheets/large overlays.
- `full` - Fully rounded/pill/circle treatment.

### `UiBorderWidthTokens` exact slots
- `none` - No border.
- `hairline` - Minimal separator/divider width.
- `subtle` - Default low-emphasis border.
- `strong` - Emphasized border.
- `focus` - Focus outline width.

### `UiOpacityTokens` exact slots
- `disabled` - Disabled component/content alpha.
- `hover` - Hover-state overlay alpha.
- `pressed` - Pressed-state overlay alpha.
- `dragged` - Dragged/active overlay alpha.
- `focus` - Focus-state overlay alpha.
- `scrim` - Modal/backdrop dimming alpha.

### `UiElevationTokens` exact slots
- `none` - Flat surfaces with no elevation.
- `raised` - Slightly lifted surfaces.
- `floating` - Floating UI elements (menus/popovers).
- `overlay` - High-priority temporary layers.
- `modal` - Highest standard elevation layer for dialogs/sheets.
- Value type: `double` logical pixels (dp).

## Component Theme Layer (V1 Foundation)

- Add a separate extension, not nested under `UiTokens`:
  - `common/common_ui/lib/src/tokens/ui_component_themes.dart`
  - `final class UiComponentThemes extends ThemeExtension<UiComponentThemes>`
- V1 scope for this layer is base scaffolding only:
  - no component-specific theme classes
  - no component-specific fields in `UiComponentThemes`
- Future resolution rule (when component themes are added):
  1. Component theme slot override
  2. Global token fallback from `UiTokens`

## Public API Changes

1. Add the token container:
- `common/common_ui/lib/src/tokens/ui_tokens.dart`
- `final class UiTokens extends ThemeExtension<UiTokens>`
- Fields:
  - `UiColorTokens color`
  - `UiTypographyTokens typography`
  - `UiSpacing spacing`
  - `UiRadiusTokens radius`
  - `UiBorderWidthTokens borderWidth`
  - `UiOpacityTokens opacity`
  - `UiElevationTokens elevation`
- Required methods:
  - `copyWith(...)`
  - `lerp(ThemeExtension<UiTokens>? other, double t)`

2. Implement token group classes in:
- `common/common_ui/lib/src/tokens/color_tokens.dart`
- `common/common_ui/lib/src/tokens/typography_tokens.dart`
- `common/common_ui/lib/src/tokens/spacing_tokens.dart`
- `common/common_ui/lib/src/tokens/radius_tokens.dart`
- `common/common_ui/lib/src/tokens/border_width_tokens.dart`
- `common/common_ui/lib/src/tokens/opacity_tokens.dart`
- `common/common_ui/lib/src/tokens/elevation_tokens.dart`

3. Add token accessor:
- `common/common_ui/lib/src/tokens/ui_tokens_extensions.dart`
- `extension UiTokensBuildContextX on BuildContext { UiTokens get uiTokens; }`

4. Add component-theme accessor:
- `common/common_ui/lib/src/tokens/ui_component_themes_extensions.dart`
- `extension UiComponentThemesBuildContextX on BuildContext { UiComponentThemes get uiComponentThemes; }`

5. Export all token APIs from:
- `common/common_ui/lib/common_ui.dart`
- Keep `UiBreakpoint` and `UiBreakpointScope` exported unchanged.

## Implementation Steps (Decision-Complete)

1. Implement all token classes with the exact slot contract above.
2. Keep all token types immutable and const-friendly where possible.
3. Implement deterministic `UiTokens.copyWith` and `UiTokens.lerp`.
4. Add dartdoc for every public class and getter, including recommended default usage per slot.
5. Implement base `UiComponentThemes` (no component-specific fields) with immutable and const-friendly API.
6. Add deterministic `copyWith`/`lerp` to `UiComponentThemes`.
7. Update `common/common_ui/lib/common_ui.dart` exports to include token and component-theme modules.
8. Update `common/common_ui/docs/tokens.md` so it matches the exact slot contract and notes component-theme base scaffolding.
9. Run `flutter analyze` for workspace-level static validation.

## Non-Goals (Out of Scope)
- No app-level migration or replacement of existing hardcoded values.
- No changes in `app/lib/**`.
- No test implementation in this iteration.
- No Material-derived token factories (`ColorScheme`, `TextTheme`) in token APIs.
- No shadow recipe system in V1 (elevation tokens provide semantic depth values only).

## Assumptions and Defaults
- Breakpoints remain scope-based (`UiBreakpointScope`) and are not moved into token APIs.
- Semantic naming stays stable and value-agnostic (except existing `sN` spacing convention).
- Color semantics are material-inspired but remain design-system-owned canonical API names.
- Typography semantics use a material-inspired 15-role scale (`display/headline/title/body/label` x `large/medium/small`).
- Token payloads use explicit values/styles and do not depend on Material mapping factories.
- V1 keeps a minimal surface hierarchy: `background`, `surface`, `surfaceRaised`.
- V1 radius API is semantic-only (`none`, `interactive`, `container`, `dialog`, `full`) without public size-scale aliases.
- V1 elevation API uses semantic depth roles (`none`, `raised`, `floating`, `overlay`, `modal`) as `double` values.
- Component-level divergence will be handled via separate `UiComponentThemes` in future iterations, not by adding ad-hoc global radius/color tokens.
