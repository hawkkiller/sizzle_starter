import 'package:flutter/material.dart';
import 'package:sizzle_starter/src/core/utils/layout/layout.dart';
import 'package:sizzle_starter/src/core/widget/popup.dart';
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
            Align(
              alignment: const Alignment(0.8, 0.0),
              child: PopupBuilder(
                flipWhenOverflow: false,
                moveWhenOverflow: false,
                resizeWhenOverflow: true,
                targetAnchor: Alignment.centerRight,
                followerAnchor: Alignment.centerLeft,
                followerBuilder: (context, controller) => PopupFollower(
                  child: Material(
                    elevation: 4,
                    child: SizedBox(
                      width: 200,
                      height: 100,
                      child: LayoutBuilder(
                        builder: (context, constraints) => Center(
                          child: Text('${constraints.maxWidth}x${constraints.maxHeight}'),
                        ),
                      ),
                    ),
                  ),
                ),
                targetBuilder: (context, controller) => ElevatedButton(
                  onPressed: () {
                    if (controller.isShowing) {
                      controller.hide();
                    } else {
                      controller.show();
                    }
                  },
                  child: const Text('Show Popup'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
