import 'package:sizzle_starter/src/core/localization/app_localization.dart';
import 'package:sizzle_starter/src/core/localization/localization_delegate.dart';

abstract class SampleStrings {
  String get appTitle;

  String samplePlaceholder(String value);
}

class SampleLocalizationDelegate extends LocalizationDelegate<SampleStrings> {
  SampleLocalizationDelegate() : super(_SampleStringsImpl.new);
}

class _SampleStringsImpl implements SampleStrings {
  _SampleStringsImpl(this._appLocalizations);

  final GeneratedLocalization _appLocalizations;

  @override
  String get appTitle => _appLocalizations.appTitle;

  @override
  String samplePlaceholder(String value) => _appLocalizations.samplePlaceholder(value);
}
