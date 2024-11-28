import 'package:clock/clock.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizzle_starter/src/core/constant/application_config.dart';
import 'package:sizzle_starter/src/core/utils/error_reporter/error_reporter.dart';
import 'package:sizzle_starter/src/core/utils/error_reporter/sentry_error_reporter.dart';
import 'package:sizzle_starter/src/core/utils/logger/logger.dart';
import 'package:sizzle_starter/src/feature/initialization/model/dependencies_container.dart';
import 'package:sizzle_starter/src/feature/settings/bloc/app_settings_bloc.dart';
import 'package:sizzle_starter/src/feature/settings/data/app_settings_datasource.dart';
import 'package:sizzle_starter/src/feature/settings/data/app_settings_repository.dart';

/// {@template composition_root}
/// A place where top-level dependencies are initialized.
/// {@endtemplate}
///
/// {@template composition_process}
/// Composition of dependencies is a process of creating and configuring
/// instances of classes that are required for the application to work.
/// {@endtemplate}
final class CompositionRoot {
  /// {@macro composition_root}
  const CompositionRoot({
    required this.config,
    required this.logger,
    required this.errorReporter,
  });

  /// Application configuration
  final ApplicationConfig config;

  /// Logger used to log information during composition process.
  final Logger logger;

  /// Error tracking manager used to track errors in the application.
  final ErrorReporter errorReporter;

  /// Composes dependencies and returns result of composition.
  Future<CompositionResult> compose() async {
    final stopwatch = clock.stopwatch()..start();

    logger.info('Initializing dependencies...');
    // initialize dependencies
    final dependencies = await DependenciesFactory(
      config: config,
      logger: logger,
      errorReporter: errorReporter,
    ).create();
    stopwatch.stop();
    logger.info('Dependencies initialized successfully in ${stopwatch.elapsedMilliseconds} ms.');
    final result = CompositionResult(
      dependencies: dependencies,
      millisecondsSpent: stopwatch.elapsedMilliseconds,
    );

    return result;
  }
}

/// {@template composition_result}
/// Result of composition
///
/// {@macro composition_process}
/// {@endtemplate}
final class CompositionResult {
  /// {@macro composition_result}
  const CompositionResult({
    required this.dependencies,
    required this.millisecondsSpent,
  });

  /// The dependencies container
  final DependenciesContainer dependencies;

  /// The number of milliseconds spent
  final int millisecondsSpent;

  @override
  String toString() => '$CompositionResult('
      'dependencies: $dependencies, '
      'millisecondsSpent: $millisecondsSpent'
      ')';
}

/// Value with time.
typedef ValueWithTime<T> = ({T value, Duration timeSpent});

/// {@template factory}
/// Factory that creates an instance of [T].
/// {@endtemplate}
abstract class Factory<T> {
  /// {@macro factory}
  const Factory();

  /// Creates an instance of [T].
  T create();
}

/// {@template async_factory}
/// Factory that creates an instance of [T] asynchronously.
/// {@endtemplate}
abstract class AsyncFactory<T> {
  /// {@macro async_factory}
  const AsyncFactory();

  /// Creates an instance of [T].
  Future<T> create();
}

/// {@template dependencies_factory}
/// Factory that creates an instance of [DependenciesContainer].
/// {@endtemplate}
class DependenciesFactory extends AsyncFactory<DependenciesContainer> {
  /// {@macro dependencies_factory}
  const DependenciesFactory({
    required this.config,
    required this.logger,
    required this.errorReporter,
  });

  /// Application configuration
  final ApplicationConfig config;

  /// Logger used to log information during composition process.
  final Logger logger;

  /// Error tracking manager used to track errors in the application.
  final ErrorReporter errorReporter;

  @override
  Future<DependenciesContainer> create() async {
    final sharedPreferences = SharedPreferencesAsync();

    final packageInfo = await PackageInfo.fromPlatform();
    final settingsBloc = await AppSettingsBlocFactory(sharedPreferences).create();

    return DependenciesContainer(
      logger: logger,
      config: config,
      errorReporter: errorReporter,
      packageInfo: packageInfo,
      appSettingsBloc: settingsBloc,
    );
  }
}

/// {@template app_logger_factory}
/// Factory that creates an instance of [AppLogger].
/// {@endtemplate}
class AppLoggerFactory extends Factory<AppLogger> {
  /// {@macro app_logger_factory}
  const AppLoggerFactory({this.observers = const []});

  /// List of observers that will be notified when a log message is received.
  final List<LogObserver> observers;

  @override
  AppLogger create() => AppLogger(observers: observers);
}

/// {@template error_reporter_factory}
/// Factory that creates an instance of [ErrorReporter].
/// {@endtemplate}
class ErrorReporterFactory extends AsyncFactory<ErrorReporter> {
  /// {@macro error_reporter_factory}
  const ErrorReporterFactory(this.config);

  /// Application configuration
  final ApplicationConfig config;

  @override
  Future<ErrorReporter> create() async {
    final errorReporter = SentryErrorReporter(
      sentryDsn: config.sentryDsn,
      environment: config.environment.value,
    );

    if (config.sentryDsn.isNotEmpty) {
      await errorReporter.initialize();
    }

    return errorReporter;
  }
}

/// {@template app_settings_bloc_factory}
/// Factory that creates an instance of [AppSettingsBloc].
///
/// The [AppSettingsBloc] should be initialized during the application startup
/// in order to load the app settings from the local storage, so user can see
/// their selected theme,locale, etc.
/// {@endtemplate}
class AppSettingsBlocFactory extends AsyncFactory<AppSettingsBloc> {
  /// {@macro app_settings_bloc_factory}
  const AppSettingsBlocFactory(this.sharedPreferences);

  /// Shared preferences instance
  final SharedPreferencesAsync sharedPreferences;

  @override
  Future<AppSettingsBloc> create() async {
    final appSettingsRepository = AppSettingsRepositoryImpl(
      datasource: AppSettingsDatasourceImpl(sharedPreferences: sharedPreferences),
    );

    final appSettings = await appSettingsRepository.getAppSettings();
    final initialState = AppSettingsState.idle(appSettings: appSettings);

    return AppSettingsBloc(
      appSettingsRepository: appSettingsRepository,
      initialState: initialState,
    );
  }
}
