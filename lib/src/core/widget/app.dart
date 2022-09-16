import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';

void main() => runZonedGuarded<Future<void>>(
      () async {
        runApp(const App());
      },
      (error, stackTrace) => log(
        'Top level exception',
        error: error,
        stackTrace: stackTrace,
        level: 1000,
        name: 'main',
      ),
    );

/// {@template app}
/// App widget
/// {@endtemplate}
class App extends StatelessWidget {
  /// {@macro app}
  const App({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
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
      );
} // App
