import 'package:blaze_starter/src/core/widget/scopes_provider.dart';
import 'package:blaze_starter/src/feature/initialization/model/initialization_progress.dart';
import 'package:blaze_starter/src/feature/initialization/widget/dependencies_scope.dart';
import 'package:blaze_starter/src/feature/initialization/widget/repositories_scope.dart';
import 'package:blaze_starter/src/feature/initialization/model/initialization_progress.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({
    required this.result,
    super.key,
  });

  final InitializationResult result;

  @override
  Widget build(BuildContext context) => ScopesProvider(
        buildScopes: [
          (child) => DependenciesScope(
                dependencies: result.dependencies,
                child: child,
              ),
          (child) => RepositoriesScope(
                repositories: result.repositories,
                child: child,
              ),
        ],
        child: MaterialApp(
          title: 'Material App',
          home: Scaffold(
            appBar: AppBar(
              title: const Text('Material App Bar'),
            ),
            body: const SafeArea(
              child: Center(
                child: Text('Hello World'),
              ),
            ),
          ),
        ),
      );
}
