import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AppLocalization {
  AppLocalization._();

  static AppLocalizations of(BuildContext context) =>
      AppLocalizations.of(context)!;

  static const supportedLocales = AppLocalizations.supportedLocales;

  static const localizationsDelegates = AppLocalizations.localizationsDelegates;
}
