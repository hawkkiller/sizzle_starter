// ignore_for_file: match-getter-setter-field-names

import 'dart:ui' show lerpDouble;

import 'package:flutter/widgets.dart';

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
  UiSpacingUnit get s2 => UiSpacingUnit(_base * 0.125);

  /// Spacing step equal to 4 px in the default profile.
  UiSpacingUnit get s4 => UiSpacingUnit(_base * .25);

  /// Spacing step equal to 8 px in the default profile.
  UiSpacingUnit get s8 => UiSpacingUnit(_base * 0.5);

  /// Spacing step equal to 12 px in the default profile.
  UiSpacingUnit get s12 => UiSpacingUnit(_base * 0.75);

  /// Spacing step equal to 16 px in the default profile.
  UiSpacingUnit get s16 => UiSpacingUnit(_base);

  /// Spacing step equal to 24 px in the default profile.
  UiSpacingUnit get s24 => UiSpacingUnit(_base * 1.5);

  /// Spacing step equal to 32 px in the default profile.
  UiSpacingUnit get s32 => UiSpacingUnit(_base * 2);

  /// Spacing step equal to 48 px in the default profile.
  UiSpacingUnit get s48 => UiSpacingUnit(_base * 3);

  /// Spacing step equal to 64 px in the default profile.
  UiSpacingUnit get s64 => UiSpacingUnit(_base * 4);

  /// Spacing step equal to 96 px in the default profile.
  UiSpacingUnit get s96 => UiSpacingUnit(_base * 6);

  /// Spacing step equal to 128 px in the default profile.
  UiSpacingUnit get s128 => UiSpacingUnit(_base * 8);

  /// Spacing step equal to 192 px in the default profile.
  UiSpacingUnit get s192 => UiSpacingUnit(_base * 12);

  /// Spacing step equal to 256 px in the default profile.
  UiSpacingUnit get s256 => UiSpacingUnit(_base * 16);

  /// Spacing step equal to 384 px in the default profile.
  UiSpacingUnit get s384 => UiSpacingUnit(_base * 24);

  /// Spacing step equal to 512 px in the default profile.
  UiSpacingUnit get s512 => UiSpacingUnit(_base * 32);

  /// Spacing step equal to 640 px in the default profile.
  UiSpacingUnit get s640 => UiSpacingUnit(_base * 40);

  /// Spacing step equal to 768 px in the default profile.
  UiSpacingUnit get s768 => UiSpacingUnit(_base * 48);

  /// Returns the configured base spacing unit.
  UiSpacingUnit get base => UiSpacingUnit(_base);

  /// Creates a copy with selected overrides.
  UiSpacing copyWith({double? base}) => UiSpacing(base: base ?? _base);

  /// Linearly interpolates this token set with another one.
  UiSpacing lerp(UiSpacing other, double t) =>
      UiSpacing(base: lerpDouble(_base, other._base, t) ?? _base);
}

extension type UiSpacingUnit(double value) implements double {
  EdgeInsets get pa => EdgeInsets.all(value);
  EdgeInsets get ph => EdgeInsets.symmetric(horizontal: value);
  EdgeInsets get pv => EdgeInsets.symmetric(vertical: value);
  EdgeInsets get pl => EdgeInsets.only(left: value);
  EdgeInsets get pr => EdgeInsets.only(right: value);
  EdgeInsets get pt => EdgeInsets.only(top: value);
  EdgeInsets get pb => EdgeInsets.only(bottom: value);
}
