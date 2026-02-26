// ignore_for_file: match-getter-setter-field-names

import 'dart:ui' show lerpDouble;

/// Spacing tokens based on a configurable base unit.
class UiSpacing {
  /// Creates spacing tokens from a base unit.
  const UiSpacing({double base = 16})
    : assert(base > 0, 'Spacing base must be greater than 0.'),
      _base = base;

  /// Creates a compact spacing profile.
  const UiSpacing.compact() : _base = 12;

  final double _base;

  /// Spacing step equal to 2 px in the default profile.
  double get s2 => _base * 0.125;

  /// Spacing step equal to 4 px in the default profile.
  double get s4 => _base * .25;

  /// Spacing step equal to 8 px in the default profile.
  double get s8 => _base * 0.5;

  /// Spacing step equal to 12 px in the default profile.
  double get s12 => _base * 0.75;

  /// Spacing step equal to 16 px in the default profile.
  double get s16 => _base;

  /// Spacing step equal to 24 px in the default profile.
  double get s24 => _base * 1.5;

  /// Spacing step equal to 32 px in the default profile.
  double get s32 => _base * 2;

  /// Spacing step equal to 48 px in the default profile.
  double get s48 => _base * 3;

  /// Spacing step equal to 64 px in the default profile.
  double get s64 => _base * 4;

  /// Spacing step equal to 96 px in the default profile.
  double get s96 => _base * 6;

  /// Spacing step equal to 128 px in the default profile.
  double get s128 => _base * 8;

  /// Spacing step equal to 192 px in the default profile.
  double get s192 => _base * 12;

  /// Spacing step equal to 256 px in the default profile.
  double get s256 => _base * 16;

  /// Spacing step equal to 384 px in the default profile.
  double get s384 => _base * 24;

  /// Spacing step equal to 512 px in the default profile.
  double get s512 => _base * 32;

  /// Spacing step equal to 640 px in the default profile.
  double get s640 => _base * 40;

  /// Spacing step equal to 768 px in the default profile.
  double get s768 => _base * 48;

  /// Returns the configured base spacing unit.
  double get base => _base;

  /// Creates a copy with selected overrides.
  UiSpacing copyWith({double? base}) => UiSpacing(base: base ?? _base);

  /// Linearly interpolates this token set with another one.
  UiSpacing lerp(UiSpacing other, double t) =>
      UiSpacing(base: lerpDouble(_base, other._base, t) ?? _base);
}
