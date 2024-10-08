import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizzle_starter/src/core/utils/extensions/string_extension.dart';
import 'package:sizzle_starter/src/core/utils/refined_logger.dart';

/// [BlocObserver] which logs all bloc state changes, errors and events.
class AppBlocObserver extends BlocObserver {
  /// Creates an instance of [AppBlocObserver] with the provided [logger].
  const AppBlocObserver(this.logger);

  /// Logger used to log information during bloc transitions.
  final RefinedLogger logger;

  @override
  void onTransition(
    Bloc<Object?, Object?> bloc,
    Transition<Object?, Object?> transition,
  ) {
    final logMessage = StringBuffer()
      ..writeln('Bloc: ${bloc.runtimeType}')
      ..writeln('Event: ${transition.event.runtimeType}')
      ..writeln('Transition: ${transition.currentState.runtimeType} => '
          '${transition.nextState.runtimeType}')
      ..write('New State: ${transition.nextState?.toString().limit(100)}');

    logger.info(logMessage.toString());
    super.onTransition(bloc, transition);
  }

  @override
  void onEvent(Bloc<Object?, Object?> bloc, Object? event) {
    final logMessage = StringBuffer()
      ..writeln('Bloc: ${bloc.runtimeType}')
      ..writeln('Event: ${event.runtimeType}')
      ..write('Details: ${event?.toString().limit(200)}');

    logger.info(logMessage.toString());
    super.onEvent(bloc, event);
  }

  @override
  void onError(BlocBase<Object?> bloc, Object error, StackTrace stackTrace) {
    final logMessage = StringBuffer()
      ..writeln('Bloc: ${bloc.runtimeType}')
      ..writeln(error.toString());

    logger.error(
      logMessage.toString(),
      error: error,
      stackTrace: stackTrace,
      printError: false,
    );
    super.onError(bloc, error, stackTrace);
  }
}
