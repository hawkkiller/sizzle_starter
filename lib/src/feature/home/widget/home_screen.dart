import 'package:flutter/material.dart';
import 'package:sizzle_starter/src/core/utils/layout/layout.dart';
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
  void initState() {
    SettingsScope.of(context, listen: false).setLocale(const Locale('ru'));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                  value: SettingsScope.textScaleOf(context).textScale,
                  onChanged: (value) {
                    SettingsScope.textScaleOf(context).setTextScale(value);
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
