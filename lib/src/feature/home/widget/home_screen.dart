import 'package:flutter/material.dart';
import 'package:sizzle_starter/src/core/common/layout/window_size.dart';
import 'package:sizzle_starter/src/feature/initialization/widget/dependencies_scope.dart';

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
  late final _logger = DependenciesScope.of(context).logger;

  @override
  void initState() {
    super.initState();
    _logger.info('Welcome To Sizzle Starter!');
  }

  @override
  Widget build(BuildContext context) {
    final windowSize = WindowSizeScope.of(context);

    return windowSize.mapWithLowerFallback(
      compact: () {
        return const Center(child: Text('Compact'));
      },
      medium: () {
        return const Center(child: Text('Medium'));
      },
      expanded: () {
        return const Center(child: Text('Expanded'));
      },
      large: () {
        return const Center(child: Text('Large'));
      },
    );
  }
}
