import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// A class which is responsible for providing the localization.
///
/// [AppLocalization] is a wrapper around [AppLocalizations].
/// 
class AppLocalization {
  AppLocalization._();

  static AppLocalizations of(BuildContext context) =>
      AppLocalizations.of(context)!;

  static const supportedLocales = AppLocalizations.supportedLocales;

  static const localizationsDelegates = AppLocalizations.localizationsDelegates;
}
