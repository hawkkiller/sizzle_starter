import 'package:flutter/material.dart';

/// Base scaffold for future component-specific theme overrides.
class UiComponentThemes extends ThemeExtension<UiComponentThemes> {
  /// Creates a base component-theme scaffold.
  const UiComponentThemes();

  @override
  UiComponentThemes copyWith() => this;

  @override
  UiComponentThemes lerp(covariant ThemeExtension<UiComponentThemes>? other, double t) {
    return this;
  }
}

/// Accesses [UiComponentThemes] from [BuildContext].
extension UiComponentThemesBuildContextX on BuildContext {
  /// Returns configured [UiComponentThemes] or an empty scaffold if missing.
  UiComponentThemes get uiComponentThemes {
    return Theme.of(this).extension<UiComponentThemes>() ?? const UiComponentThemes();
  }
}
