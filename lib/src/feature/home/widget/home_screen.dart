import 'package:flutter/material.dart';
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
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Welcome to Sizzle Starter!',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      );
}
