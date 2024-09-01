import 'package:flutter/material.dart';
import 'package:sizzle_starter/src/core/utils/layout/layout.dart';
import 'package:sizzle_starter/src/feature/settings/bloc/app_settings_bloc.dart';
import 'package:sizzle_starter/src/feature/settings/widget/settings_scope.dart';

/// {@template home_screen}
/// HomeScreen is a simple screen that displays a grid of items.
/// {@endtemplate}
class HomeScreen extends StatefulWidget {
  /// {@macro home_screen}
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final appSettings = SettingsScope.settingsOf(context);
    final windowSize = WindowSizeScope.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Home Screen')),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              children: [
                const Text('Text scale'),
                Slider(
                  divisions: 8,
                  min: 0.5,
                  max: 2,
                  value: SettingsScope.settingsOf(context).textScale ?? 1,
                  onChanged: (value) {
                    SettingsScope.of(context).add(
                      AppSettingsEvent.updateAppSettings(
                        appSettings: appSettings.copyWith(textScale: value),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          SliverPadding(
            padding: HorizontalSpacing.centered(windowSize.width, 1600),
            sliver: SliverGrid.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                crossAxisCount: windowSize.maybeMap(
                  medium: () => 2,
                  expanded: () => 3,
                  large: () => 4,
                  extraLarge: () => 5,
                  orElse: () => 1,
                ),
              ),
              itemBuilder: (context, index) => ColoredBox(
                color: Theme.of(context).colorScheme.primary,
                child: Center(
                  child: Text(
                    'Item $index',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
