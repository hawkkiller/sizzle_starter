import 'dart:convert';

import 'package:flutter/material.dart';

@pragma('vm:prefer-inline')
Color? _colorOrNull(int? value) => value != null ? Color(value) : null;

/// {@template color_scheme_codec}
const colorSchemeCodec = ColorSchemeCodec();

/// {@macro color_scheme_codec}
/// [Codec] used to encode and decode [ColorScheme] to and from JSON.
/// {@endtemplate}
final class ColorSchemeCodec extends Codec<ColorScheme, Map<String, Object?>> {
  /// {@macro color_scheme_codec}
  const ColorSchemeCodec();

  @override
  Converter<Map<String, Object?>, ColorScheme> get decoder =>
      const _ColorSchemeDecoder();

  @override
  Converter<ColorScheme, Map<String, Object?>> get encoder =>
      const _ColorSchemeEncoder();
}

final class _ColorSchemeDecoder
    extends Converter<Map<String, Object?>, ColorScheme> {
  const _ColorSchemeDecoder();

  @override
  ColorScheme convert(Map<String, Object?> input) {
    if (input
        case {
          'brightness': final String? brightness,
          'primary': final int primary,
          'primaryContainer': final int? primaryContainer,
          'onPrimary': final int onPrimary,
          'onPrimaryContainer': final int? onPrimaryContainer,
          'secondary': final int secondary,
          'secondaryContainer': final int? secondaryContainer,
          'onSecondary': final int onSecondary,
          'onSecondaryContainer': final int? onSecondaryContainer,
          'tertiary': final int? tertiary,
          'onTertiary': final int? onTertiary,
          'tertiaryContainer': final int? tertiaryContainer,
          'onTertiaryContainer': final int? onTertiaryContainer,
          'surface': final int surface,
          'onSurface': final int onSurface,
          'background': final int background,
          'onBackground': final int onBackground,
          'error': final int error,
          'onError': final int onError,
          'errorContainer': final int? errorContainer,
          'onErrorContainer': final int? onErrorContainer,
          'surfaceVariant': final int? surfaceVariant,
          'onSurfaceVariant': final int? onSurfaceVariant,
          'outline': final int? outline,
          'outlineVariant': final int? outlineVariant,
          'shadow': final int? shadow,
          'scrim': final int? scrim,
          'inverseSurface': final int? inverseSurface,
          'onInverseSurface': final int? onInverseSurface,
          'inversePrimary': final int? inversePrimary,
          'surfaceTint': final int? surfaceTint,
        }) {
      return ColorScheme(
        primary: Color(primary),
        secondary: Color(secondary),
        surface: Color(surface),
        background: Color(background),
        error: Color(error),
        onPrimary: Color(onPrimary),
        onSecondary: Color(onSecondary),
        onSurface: Color(onSurface),
        onBackground: Color(onBackground),
        onError: Color(onError),
        primaryContainer: _colorOrNull(primaryContainer),
        secondaryContainer: _colorOrNull(secondaryContainer),
        errorContainer: _colorOrNull(errorContainer),
        onPrimaryContainer: _colorOrNull(onPrimaryContainer),
        onSecondaryContainer: _colorOrNull(onSecondaryContainer),
        onErrorContainer: _colorOrNull(onErrorContainer),
        tertiary: _colorOrNull(tertiary),
        onTertiary: _colorOrNull(onTertiary),
        tertiaryContainer: _colorOrNull(tertiaryContainer),
        onTertiaryContainer: _colorOrNull(onTertiaryContainer),
        surfaceVariant: _colorOrNull(surfaceVariant),
        onSurfaceVariant: _colorOrNull(onSurfaceVariant),
        outline: _colorOrNull(outline),
        outlineVariant: _colorOrNull(outlineVariant),
        shadow: _colorOrNull(shadow),
        scrim: _colorOrNull(scrim),
        inverseSurface: _colorOrNull(inverseSurface),
        onInverseSurface: _colorOrNull(onInverseSurface),
        inversePrimary: _colorOrNull(inversePrimary),
        surfaceTint: _colorOrNull(surfaceTint),
        brightness: switch (brightness) {
          'light' => Brightness.light,
          'dark' => Brightness.dark,
          _ => throw FormatException('Unknown brightness: $brightness'),
        },
      );
    }
    throw const FormatException('Invalid ColorScheme JSON');
  }
}

final class _ColorSchemeEncoder
    extends Converter<ColorScheme, Map<String, Object?>> {
  const _ColorSchemeEncoder();

  @override
  Map<String, Object?> convert(ColorScheme input) {
    final json = <String, Object?>{
      'brightness': input.brightness.name,
      'primary': input.primary.value,
      'onPrimary': input.onPrimary.value,
      'primaryContainer': input.primaryContainer.value,
      'onPrimaryContainer': input.onPrimaryContainer.value,
      'secondary': input.secondary.value,
      'onSecondary': input.onSecondary.value,
      'secondaryContainer': input.secondaryContainer.value,
      'onSecondaryContainer': input.onSecondaryContainer.value,
      'surface': input.surface.value,
      'onSurface': input.onSurface.value,
      'background': input.background.value,
      'onBackground': input.onBackground.value,
      'error': input.error.value,
      'onError': input.onError.value,
      'errorContainer': input.errorContainer.value,
      'onErrorContainer': input.onErrorContainer.value,
      'tertiary': input.tertiary.value,
      'onTertiary': input.onTertiary.value,
      'tertiaryContainer': input.tertiaryContainer.value,
      'onTertiaryContainer': input.onTertiaryContainer.value,
      'surfaceVariant': input.surfaceVariant.value,
      'onSurfaceVariant': input.onSurfaceVariant.value,
      'outline': input.outline.value,
      'outlineVariant': input.outlineVariant.value,
      'shadow': input.shadow.value,
      'scrim': input.scrim.value,
      'inverseSurface': input.inverseSurface.value,
      'onInverseSurface': input.onInverseSurface.value,
      'inversePrimary': input.inversePrimary.value,
      'surfaceTint': input.surfaceTint.value,
    };

    return json;
  }
}
