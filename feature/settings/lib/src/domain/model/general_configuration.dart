import 'dart:ui' show Locale;

class GeneralConfiguration {
  const GeneralConfiguration({this.locale = const Locale('en')});

  final Locale locale;

  GeneralConfiguration copyWith({Locale? locale}) {
    return GeneralConfiguration(locale: locale ?? this.locale);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GeneralConfiguration && runtimeType == other.runtimeType && locale == other.locale;

  @override
  int get hashCode => locale.hashCode;
}
