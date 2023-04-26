import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:sizzle_starter/src/core/utils/extensions/context_extension.dart';
import 'package:sizzle_starter/src/feature/sample/localization/sample_localization_delegate.dart';

/// {@template sample_page}
/// SamplePage widget
/// {@endtemplate}
@RoutePage()
class SampleScreen extends StatelessWidget {
  /// {@macro sample_page}
  const SampleScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(context.stringOf<SampleStrings>().appTitle),
        ),
        body: Column(
          children: [
            Text(
              context.stringOf<SampleStrings>().samplePlaceholder('Misha'),
            ),
          ],
        ),
      );
}
