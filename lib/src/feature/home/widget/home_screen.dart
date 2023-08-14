import 'package:flutter/material.dart';
import 'package:sizzle_starter/src/core/localization/localization.dart';

/// {@template sample_page}
/// SamplePage widget
/// {@endtemplate}
class HomeScreen extends StatelessWidget {
  /// {@macro sample_page}
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(Localization.of(context).appTitle),
        ),
        body: Column(
          children: [
            Text(
              Localization.of(context).samplePlaceholder('Sizzle Starter'),
            ),
          ],
        ),
      );
}
