import 'package:common_translations/src/l10n/generated/common_translations_localizations.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

export 'src/l10n/generated/common_translations_localizations.dart';

/// Provides localization delegates and supported locales for the package.
abstract final class CommonTranslations {
  /// The delegates required to load package and Flutter SDK localizations.
  static const localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    CommonTranslationsLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// The locales supported by the package translations.
  static const supportedLocales = CommonTranslationsLocalizations.supportedLocales;
}

/// Extension methods on [BuildContext] for working with common translations.
extension CommonTranslationsExtension on BuildContext {
  /// Get the [CommonTranslationsLocalizations] instance for the current context.
  CommonTranslationsLocalizations get translations => CommonTranslationsLocalizations.of(this);
}
