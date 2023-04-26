import 'package:flutter/material.dart';
import 'package:sizzle_starter/src/core/localization/generated/generated_localizations.dart';

abstract class LocalizationDelegate<T> extends LocalizationsDelegate<T> {
  LocalizationDelegate(this._delegateFactory);

  final T Function(GeneratedLocalizations appLocalizations) _delegateFactory;

  @override
  Future<T> load(Locale locale) async {
    final appLocalizations = await GeneratedLocalizations.delegate.load(locale);
    return _delegateFactory(appLocalizations);
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<T> old) => false;

  @override
  bool isSupported(Locale locale) => GeneratedLocalizations.delegate.isSupported(locale);
}
