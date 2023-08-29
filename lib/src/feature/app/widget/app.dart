import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:sizzle_starter/src/feature/app/widget/locale_scope.dart';
import 'package:sizzle_starter/src/feature/app/widget/material_context.dart';
import 'package:sizzle_starter/src/feature/app/widget/theme_scope.dart';
import 'package:sizzle_starter/src/feature/initialization/logic/initialization_processor.dart';
import 'package:sizzle_starter/src/feature/initialization/model/dependencies.dart';
import 'package:sizzle_starter/src/feature/initialization/widget/dependencies_scope.dart';

/// {@template app}
/// [App] is an entry point to the application.
///
/// All the global scopes should be defined there.
/// {@endtemplate}
class App extends StatelessWidget {
  /// {@macro app}
  const App({
    required this.result,
    super.key,
  });

  /// Running this function will result in attaching
  /// corresponding [RenderObject] to the root of the tree.
  void attach() => runApp(this);

  /// The initialization result from the [InitializationProcessor]
  final InitializationResult result;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      DiagnosticsProperty<InitializationResult>(
        'result',
        result,
        description: 'The initialization result from the '
            '[InitializationProcessor]',
      ),
    );
  }

  @override
  Widget build(BuildContext context) => DefaultAssetBundle(
        bundle: SentryAssetBundle(),
        child: DependenciesScope(
          dependencies: result.dependencies,
          child: const ThemeScope(
            child: LocaleScope(
              child: MaterialContext(),
            ),
          ),
        ),
      );
}
