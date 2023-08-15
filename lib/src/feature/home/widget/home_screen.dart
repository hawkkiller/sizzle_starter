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
  Widget build(BuildContext context) {
    final themeScope = ThemeScope.of(context);
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            actions: [
              if (!ThemeScope.of(context).theme.type.isSystem)
                Switch(
                  thumbColor: MaterialStatePropertyAll(
                    themeScope.theme.colorScheme?.onPrimaryContainer,
                  ),
                  trackColor: MaterialStatePropertyAll(
                    themeScope.theme.colorScheme?.onPrimaryContainer
                        .withOpacity(
                      0.5,
                    ),
                  ),
                  thumbIcon: MaterialStateProperty.resolveWith((states) {
                    if (states.contains(MaterialState.selected)) {
                      return Icon(
                        Icons.nightlight_round,
                        color: themeScope.theme.colorScheme?.onPrimary,
                      );
                    }
                    return Icon(
                      Icons.wb_sunny,
                      color: themeScope.theme.colorScheme?.onPrimary,
                    );
                  }),
                  value: ThemeScope.of(context).theme.colorScheme?.brightness ==
                      Brightness.light,
                  onChanged: (value) {
                    final theme = ThemeScope.of(context).theme;
                    final brightness = theme.colorScheme?.brightness;

                    if (brightness == Brightness.light) {
                      ThemeScope.of(context).setTheme(
                        theme.copyWith(
                          colorScheme: theme.colorScheme?.copyWith(
                            brightness: Brightness.dark,
                          ),
                        ),
                      );
                    } else {
                      ThemeScope.of(context).setTheme(
                        theme.copyWith(
                          colorScheme: theme.colorScheme?.copyWith(
                            brightness: Brightness.light,
                          ),
                        ),
                      );
                    }
                  },
                ),
            ],
            title: Text(Localization.of(context).appTitle),
          ),
          const SliverToBoxAdapter(
            child: _ThemeSelector(),
          ),
        ],
      ),
    );
  }
}

class _ThemeSelector extends StatelessWidget {
  const _ThemeSelector();

  @override
  Widget build(BuildContext context) => SizedBox(
        height: 100,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: AppTheme.values.length,
          itemBuilder: (context, index) {
            final theme = AppTheme.values[index];

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
            onTap: () => ThemeScope.of(context).setTheme(
              _theme.copyWith(
                colorScheme: _theme.colorScheme?.copyWith(
                  brightness:
                      ThemeScope.of(context).theme.colorScheme?.brightness,
                ),
              ),
            ),
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
