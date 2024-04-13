import 'package:flutter/material.dart';
import 'package:sizzle_starter/src/core/utils/layout/layout.dart';

/// {@template home_screen}
/// HomeScreen is a simple screen that displays a grid of items.
/// {@endtemplate}
class HomeScreen extends StatelessWidget {
  /// {@macro home_screen}
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final windowWidth = MediaQuery.sizeOf(context).width;
    return Scaffold(
      appBar: AppBar(title: const Text('Home Screen')),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final windowSize = constraints.materialBreakpoint;
          return CustomScrollView(
            slivers: [
              SliverPadding(
                padding: HorizontalSpacing.centered(windowWidth),
                sliver: SliverGrid.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    crossAxisCount: switch (windowSize) {
                      WindowSize.compact => 2,
                      <= WindowSize.expanded => 3,
                      _ => 4,
                    },
                  ),
                  itemBuilder: (context, index) => ColoredBox(
                    color: Theme.of(context).colorScheme.primary,
                    child: Center(
                      child: Text(
                        'Item $index',
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
