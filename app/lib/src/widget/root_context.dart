import 'package:flutter/material.dart';
import 'package:sizzle_starter/src/logic/composition_root.dart';
import 'package:sizzle_starter/src/widget/dependencies_scope.dart';
import 'package:sizzle_starter/src/widget/material_context.dart';
import 'package:ui_library/ui_library.dart';

/// [RootContext] is an entry point to the application.
///
/// If a scope doesn't depend on any inherited widget returned by
/// [MaterialApp] or [WidgetsApp], like [Directionality] or [Theme],
/// and it should be available in the whole application, it should be
/// placed here.
class RootContext extends StatelessWidget {
  const RootContext({required this.compositionResult, super.key});

  final CompositionResult compositionResult;

  @override
  Widget build(BuildContext context) {
    return DependenciesScope(
      dependencies: compositionResult.dependencies,
      child: const WindowSizeScope(child: MaterialContext()),
    );
  }
}
