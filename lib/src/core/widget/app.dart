import 'package:blaze_starter/src/core/widget/app_context.dart';
import 'package:blaze_starter/src/core/widget/scopes_provider.dart';
import 'package:blaze_starter/src/feature/initialization/model/initialization_progress.dart';
import 'package:blaze_starter/src/feature/initialization/widget/dependencies_scope.dart';
import 'package:blaze_starter/src/feature/initialization/widget/repositories_scope.dart';
import 'package:flutter/material.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class App extends StatelessWidget {
  const App({
    required this.result,
    super.key,
  });

  void run() => runApp(
        DefaultAssetBundle(
          bundle: SentryAssetBundle(),
          child: this,
        ),
      );

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
        child: const AppContext(),
      );
}
