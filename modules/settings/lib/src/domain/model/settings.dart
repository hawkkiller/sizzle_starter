import 'dart:ui' show Locale;

import 'package:flutter/foundation.dart';
import 'package:settings/src/domain/model/theme_configuration.dart';

/// Settings for the app.
class SettingsVO with Diagnosticable {
  const SettingsVO({this.themeConfiguration, this.locale, this.textScale});

  final ThemeConfigurationVO? themeConfiguration;
  final Locale? locale;
  final double? textScale;

  SettingsVO copyWith({
    ThemeConfigurationVO? themeConfiguration,
    Locale? locale,
    double? textScale,
  }) => SettingsVO(
    themeConfiguration: themeConfiguration ?? this.themeConfiguration,
    locale: locale ?? this.locale,
    textScale: textScale ?? this.textScale,
  );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SettingsVO &&
        other.themeConfiguration == themeConfiguration &&
        other.locale == locale &&
        other.textScale == textScale;
  }

  @override
  int get hashCode => Object.hash(themeConfiguration, locale, textScale);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties.add(
      DiagnosticsProperty<ThemeConfigurationVO>('themeConfiguration', themeConfiguration),
    );
    properties.add(DiagnosticsProperty<Locale>('locale', locale));
    properties.add(DoubleProperty('textScale', textScale));
    super.debugFillProperties(properties);
  }
}
