// ignore_for_file: match-getter-setter-field-names

class UiSpacing {
  const UiSpacing({double base = 16}) : _base = base;
  const UiSpacing.compact() : _base = 12;

  final double _base;

  double get s4 => _base * .25;
  double get s8 => _base * 0.5;
  double get s12 => _base * 0.75;
  double get s16 => _base;
  double get s24 => _base * 1.5;
  double get s32 => _base * 2;
  double get s48 => _base * 3;
  double get s64 => _base * 4;
  double get s96 => _base * 6;
  double get s128 => _base * 8;
  double get s192 => _base * 12;
  double get s256 => _base * 16;
  double get s384 => _base * 24;
  double get s512 => _base * 32;
  double get s640 => _base * 40;
  double get s768 => _base * 48;
}
