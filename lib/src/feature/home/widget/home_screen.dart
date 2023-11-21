import 'package:flutter/material.dart';
import 'package:sizzle_starter/src/core/localization/localization.dart';
import 'package:sizzle_starter/src/feature/settings/widget/settings_scope.dart';

/// {@template sample_page}
/// SamplePage widget
/// {@endtemplate}
class HomeScreen extends StatelessWidget {
  /// {@macro sample_page}
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: CustomScrollView(
          slivers: [
            SliverAppBar(title: Text(Localization.of(context).appTitle)),
            SliverList(
              delegate: SliverChildListDelegate.fixed([
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    Localization.of(context).locales,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                  ),
                ),
                _LanguagesSelector(Localization.supportedLocales),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    Localization.of(context).default_themes,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                  ),
                ),
                const _ThemeSelector(Colors.primaries),
                Padding(
                  padding: const EdgeInsets.only(left: 8, top: 8),
                  child: Text(
                    Localization.of(context).custom_colors,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                  ),
                ),
                const _ThemeSelector(Colors.accents),
              ]),
            ),
            SliverToBoxAdapter(
              child: Center(
                child: SizedBox(
                  height: 100,
                  width: 100,
                  child: Card(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    margin: const EdgeInsets.all(8),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
}

class _LanguagesSelector extends StatelessWidget {
  const _LanguagesSelector(this._languages);

  final List<Locale> _languages;

  @override
  Widget build(BuildContext context) => SizedBox(
        height: 100,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: _languages.length,
          itemBuilder: (context, index) {
            final language = _languages.elementAt(index);

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: _LanguageCard(language),
            );
          },
        ),
      );
}

class _LanguageCard extends StatelessWidget {
  const _LanguageCard(this._language);

  final Locale _language;

  @override
  Widget build(BuildContext context) => Card(
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(4),
          ),
          child: InkWell(
            onTap: () => SettingsScope.localeOf(context).setLocale(_language),
            borderRadius: BorderRadius.circular(4),
            child: SizedBox(
              width: 64,
              child: Center(
                child: Text(
                  _language.languageCode,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                ),
              ),
            ),
          ),
        ),
      );
}

class _ThemeSelector extends StatelessWidget {
  const _ThemeSelector(this._colors);

  final List<Color> _colors;

  @override
  Widget build(BuildContext context) => SizedBox(
        height: 100,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: _colors.length,
          itemBuilder: (context, index) {
            final color = _colors.elementAt(index);

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: _ThemeCard(color),
            );
          },
        ),
      );
}

class _ThemeCard extends StatelessWidget {
  const _ThemeCard(this._color);

  final Color _color;

  @override
  Widget build(BuildContext context) => Card(
        child: Material(
          color: _color,
          borderRadius: BorderRadius.circular(4),
          child: InkWell(
            onTap: () {
              SettingsScope.themeOf(context).setThemeSeedColor(_color);
            },
            borderRadius: BorderRadius.circular(4),
            child: const SizedBox.square(dimension: 64),
          ),
        ),
      );
}
