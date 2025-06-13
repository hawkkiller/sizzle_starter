// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class GeneratedLocalizations {
  GeneratedLocalizations();

  static GeneratedLocalizations? _current;

  static GeneratedLocalizations get current {
    assert(
      _current != null,
      'No instance of GeneratedLocalizations was loaded. Try to initialize the GeneratedLocalizations delegate before accessing GeneratedLocalizations.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<GeneratedLocalizations> load(Locale locale) {
    final name =
        (locale.countryCode?.isEmpty ?? false)
            ? locale.languageCode
            : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = GeneratedLocalizations();
      GeneratedLocalizations._current = instance;

      return instance;
    });
  }

  static GeneratedLocalizations of(BuildContext context) {
    final instance = GeneratedLocalizations.maybeOf(context);
    assert(
      instance != null,
      'No instance of GeneratedLocalizations present in the widget tree. Did you add GeneratedLocalizations.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static GeneratedLocalizations? maybeOf(BuildContext context) {
    return Localizations.of<GeneratedLocalizations>(
      context,
      GeneratedLocalizations,
    );
  }

  /// `sizzle_starter`
  String get appTitle {
    return Intl.message('sizzle_starter', name: 'appTitle', desc: '', args: []);
  }
}

class AppLocalizationDelegate
    extends LocalizationsDelegate<GeneratedLocalizations> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[Locale.fromSubtags(languageCode: 'en')];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<GeneratedLocalizations> load(Locale locale) =>
      GeneratedLocalizations.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
