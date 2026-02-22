import 'dart:ui';

import 'package:oklab_flutter/oklab_flutter.dart';

class UiColorScale {
  const UiColorScale({
    required this.shade50,
    required this.shade100,
    required this.shade200,
    required this.shade300,
    required this.shade400,
    required this.shade500,
    required this.shade600,
    required this.shade700,
    required this.shade800,
    required this.shade900,
    required this.shade950,
  });

  /// Background surfaces (subtle), highlights, very light backgrounds
  final Color shade50;

  /// Backgrounds, lighter containers, subtle UI elements
  final Color shade100;

  /// Secondary backgrounds, chips, muted components
  final Color shade200;

  /// Elevated backgrounds, borders, input fields, tint backgrounds
  final Color shade300;

  /// Tertiary accents, icons (muted), hover states
  final Color shade400;

  /// Middle intensity, active icons, selected states
  final Color shade500;

  /// Primary accents, buttons, links, fill accent color
  final Color shade600;

  /// Button hover/pressed, selected, accent strokes
  final Color shade700;

  /// Stronger foreground, text on light, icons
  final Color shade800;

  /// Primary text, heading text, icons on light
  final Color shade900;

  /// Purest, highest contrast foreground, outlines on light backgrounds
  final Color shade950;
}

class UiColorScaleOklch extends UiColorScale {
  UiColorScaleOklch(double hue, {double peakC = 0.18})
    : super(
        shade50: OklchColor(.97, peakC * 0.11, hue).toColor(),
        shade100: OklchColor(.93, peakC * 0.28, hue).toColor(),
        shade200: OklchColor(.87, peakC * 0.50, hue).toColor(),
        shade300: OklchColor(.79, peakC * 0.72, hue).toColor(),
        shade400: OklchColor(.70, peakC * 0.89, hue).toColor(),
        shade500: OklchColor(.60, peakC, hue).toColor(),
        shade600: OklchColor(.50, peakC * 0.89, hue).toColor(),
        shade700: OklchColor(.42, peakC * 0.72, hue).toColor(),
        shade800: OklchColor(.35, peakC * 0.56, hue).toColor(),
        shade900: OklchColor(.27, peakC * 0.39, hue).toColor(),
        shade950: OklchColor(.18, peakC * 0.22, hue).toColor(),
      );
}
