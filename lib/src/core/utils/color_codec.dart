import 'dart:convert';
import 'dart:ui' show Color;

/// A codec for encoding and decoding [Color] objects.
const colorCodec = ColorCodec();

/// {@template color_codec}
/// A codec for encoding and decoding [Color] objects.
/// {@endtemplate}
class ColorCodec extends Codec<Color, int> {
  /// {@macro color_codec}
  const ColorCodec();

  @override
  Converter<int, Color> get decoder => const _ColorDecoder();

  @override
  Converter<Color, int> get encoder => const _ColorEncoder();
}

class _ColorEncoder extends Converter<Color, int> {
  const _ColorEncoder();

  static int _floatToInt8(double x) => (x * 255.0).round() & 0xff;

  @override
  int convert(Color input) =>
      _floatToInt8(input.a) << 24 |
      _floatToInt8(input.r) << 16 |
      _floatToInt8(input.g) << 8 |
      _floatToInt8(input.b) << 0;
}

class _ColorDecoder extends Converter<int, Color> {
  const _ColorDecoder();

  @override
  Color convert(int input) => Color(input);
}
