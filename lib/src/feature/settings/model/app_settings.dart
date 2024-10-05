import 'dart:ui' show Locale;

import 'package:flutter/foundation.dart';
import 'package:sizzle_starter/src/feature/initialization/model/app_theme.dart';

/// {@template app_settings}
/// Application settings
/// {@endtemplate}
class AppSettings with Diagnosticable {
  /// {@macro app_settings}
  const AppSettings({this.appTheme, this.locale, this.textScale});

  /// The theme of the app,
  final AppTheme? appTheme;

  /// The locale of the app.
  final Locale? locale;

  /// The text scale of the app.
  final double? textScale;

  /// Copy the [AppSettings] with new values.
  AppSettings copyWith({
    AppTheme? appTheme,
    Locale? locale,
    double? textScale,
  }) =>
      AppSettings(
        appTheme: appTheme ?? this.appTheme,
        locale: locale ?? this.locale,
        textScale: textScale ?? this.textScale,
      );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AppSettings &&
        other.appTheme == appTheme &&
        other.locale == locale &&
        other.textScale == textScale;
  }

  @override
  int get hashCode => Object.hash(appTheme, locale, textScale);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties.add(DiagnosticsProperty<AppTheme>('appTheme', appTheme));
    properties.add(DiagnosticsProperty<Locale>('locale', locale));
    properties.add(DoubleProperty('textScale', textScale));
    super.debugFillProperties(properties);
  }
}
