import 'package:flutter/material.dart';
import 'package:sizzle_starter/src/core/localization/localization.dart';
import 'package:sizzle_starter/src/feature/app/model/app_theme.dart';
import 'package:sizzle_starter/src/feature/app/widget/theme_scope.dart';

/// {@template sample_page}
/// SamplePage widget
/// {@endtemplate}
class HomeScreen extends StatefulWidget {
  /// {@macro sample_page}
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              title: Text(Localization.of(context).appTitle),
            ),
            SliverList(
              delegate: SliverChildListDelegate.fixed([
                Text(
                  Localization.of(context).light_themes,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                _ThemeSelector(AppTheme.lightValues),
              ]),
            ),
            SliverList(
              delegate: SliverChildListDelegate.fixed([
                Text(
                  Localization.of(context).dark_themes,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                _ThemeSelector(AppTheme.darkValues),
              ]),
            ),
          ],
        ),
      );
}

class _ThemeSelector extends StatelessWidget {
  const _ThemeSelector(this._themes);

  final List<AppTheme> _themes;

  @override
  Widget build(BuildContext context) => SizedBox(
        height: 100,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: _themes.length,
          itemBuilder: (context, index) {
            final theme = _themes[index];

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: _ThemeCard(theme),
            );
          },
        ),
      );
}

class _ThemeCard extends StatelessWidget {
  const _ThemeCard(this._theme);

  final AppTheme _theme;

  @override
  Widget build(BuildContext context) => Card(
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: _theme.colorScheme?.primary,
            borderRadius: BorderRadius.circular(4),
          ),
          child: InkWell(
            onTap: () => ThemeScope.of(context).setTheme(_theme),
            borderRadius: BorderRadius.circular(4),
            child: SizedBox(
              width: 64,
              child: Center(
                child: Text(
                  _theme.type.name,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: _theme.colorScheme?.onPrimary,
                      ),
                ),
              ),
            ),
          ),
        ),
      );
}
