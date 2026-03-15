import 'package:common_ui/common_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

const _wcagAaMinimumContrastRatio = 4.5;

void main() {
  final color = SandgoldTheme().color;
  final cases = <({String name, Color foreground, Color background})>[
    (name: 'onPrimary on primary', foreground: color.onPrimary, background: color.primary),
    (name: 'onSuccess on success', foreground: color.onSuccess, background: color.success),
    (
      name: 'onSuccessContainer on successContainer',
      foreground: color.onSuccessContainer,
      background: color.successContainer,
    ),
    (name: 'onWarning on warning', foreground: color.onWarning, background: color.warning),
    (
      name: 'onWarningContainer on warningContainer',
      foreground: color.onWarningContainer,
      background: color.warningContainer,
    ),
    (name: 'onError on error', foreground: color.onError, background: color.error),
    (
      name: 'onErrorContainer on errorContainer',
      foreground: color.onErrorContainer,
      background: color.errorContainer,
    ),
    (name: 'onInfo on info', foreground: color.onInfo, background: color.info),
    (
      name: 'onInfoContainer on infoContainer',
      foreground: color.onInfoContainer,
      background: color.infoContainer,
    ),
  ];

  group('semantic color pairs', () {
    for (final pair in cases) {
      test('${pair.name} meets WCAG AA contrast', () {
        expect(pair.foreground, hasMinimumContrastOn(pair.background));
      });
    }
  });
}

Matcher hasMinimumContrastOn(
  Color background, {
  double minimumRatio = _wcagAaMinimumContrastRatio,
}) {
  return _HasMinimumContrastOn(background, minimumRatio: minimumRatio);
}

class _HasMinimumContrastOn extends Matcher {
  const _HasMinimumContrastOn(this.background, {required this.minimumRatio});

  final Color background;
  final double minimumRatio;

  @override
  Description describe(Description description) {
    return description.add(
      'a color with a contrast ratio of at least '
      '$minimumRatio on ${background.toARGB32().toRadixString(16)}',
    );
  }

  @override
  bool matches(Object? item, Map<Object?, Object?> matchState) {
    if (item is! Color) {
      return false;
    }

    final ratio = _contrastRatio(item, background);
    matchState[#ratio] = ratio;
    matchState[#foreground] = item;

    return ratio >= minimumRatio;
  }

  @override
  Description describeMismatch(
    Object? item,
    Description mismatchDescription,
    Map<Object?, Object?> matchState,
    bool verbose,
  ) {
    final ratio = matchState[#ratio] as double?;
    final foreground = matchState[#foreground] as Color?;

    if (ratio == null || foreground == null) {
      return mismatchDescription.add('was not a color');
    }

    return mismatchDescription.add(
      'had contrast ratio ${ratio.toStringAsFixed(2)} '
      'for foreground ${foreground.toARGB32().toRadixString(16)} '
      'on background ${background.toARGB32().toRadixString(16)}',
    );
  }
}

double _contrastRatio(Color foreground, Color background) {
  final foregroundLuminance = foreground.computeLuminance();
  final backgroundLuminance = background.computeLuminance();
  final lighter = foregroundLuminance > backgroundLuminance
      ? foregroundLuminance
      : backgroundLuminance;
  final darker = foregroundLuminance > backgroundLuminance
      ? backgroundLuminance
      : foregroundLuminance;

  return (lighter + 0.05) / (darker + 0.05);
}
