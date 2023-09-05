import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizzle_starter/src/feature/app/data/locale_datasource.dart';
import 'package:sizzle_starter/src/feature/app/data/locale_repository.dart';
import 'package:sizzle_starter/src/feature/app/data/theme_datasource.dart';
import 'package:sizzle_starter/src/feature/app/data/theme_repository.dart';
import 'package:sizzle_starter/src/feature/initialization/model/dependencies.dart';
import 'package:sizzle_starter/src/feature/initialization/model/initialization_progress.dart';

/// A function which represents a single initialization step.
typedef StepAction = FutureOr<void>? Function(InitializationProgress progress);

/// The initialization steps, which are executed in the order they are defined.
///
/// The [Dependencies] object is passed to each step, which allows the step to
/// set the dependency, and the next step to use it.
mixin InitializationSteps {
  /// The initialization steps,
  /// which are executed in the order they are defined.
  final initializationSteps = <String, StepAction>{
    'Shared Preferences': (progress) async {
      final sharedPreferences = await SharedPreferences.getInstance();
      progress.dependencies.sharedPreferences = sharedPreferences;
    },
    'Theme Repository': (progress) async {
      final sharedPreferences = progress.dependencies.sharedPreferences;
      final themeDataSource = ThemeDataSourceImpl(sharedPreferences);
      progress.dependencies.themeRepository = ThemeRepositoryImpl(
        themeDataSource,
      );
    },
    'Locale Repository': (progress) async {
      final sharedPreferences = progress.dependencies.sharedPreferences;
      final localeDataSource = LocaleDataSourceImpl(
        sharedPreferences: sharedPreferences,
      );
      progress.dependencies.localeRepository = LocaleRepositoryImpl(
        localeDataSource,
      );
    },
  };
}
