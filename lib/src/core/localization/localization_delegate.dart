import 'package:flutter/material.dart';
import 'package:sizzle_starter/src/core/localization/app_localization.dart';

abstract class LocalizationDelegate<T> extends LocalizationsDelegate<T> {
  LocalizationDelegate(this._delegateFactory);

  final T Function(GeneratedLocalization appLocalizations) _delegateFactory;

  @override
  Future<T> load(Locale locale) async {
    final appLocalizations = await GeneratedLocalization.delegate.load(locale);
    return _delegateFactory(appLocalizations);
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<T> old) => false;

  @override
  bool isSupported(Locale locale) => GeneratedLocalization.delegate.isSupported(locale);
}
