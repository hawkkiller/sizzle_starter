import 'package:blaze_starter/src/core/localization/app_localization.dart';
import 'package:flutter/material.dart';

class AppContext extends StatelessWidget {
  const AppContext({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        supportedLocales: AppLocalization.supportedLocales,
        localizationsDelegates: AppLocalization.localizationsDelegates,
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
}
