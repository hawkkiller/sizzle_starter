import 'package:common_logger/common_logger.dart';
import 'package:common_utils/common_utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// [BlocObserver] that logs state transitions and errors.
class AppBlocObserver extends BlocObserver {
  /// Creates an instance of [AppBlocObserver] with the provided [logger].
  const AppBlocObserver(this.logger);

  /// Logger used to log bloc lifecycle events.
  final Logger logger;

  @override
  void onTransition(Bloc<Object?, Object?> bloc, Transition<Object?, Object?> transition) {
    logger.info(
      '${bloc.runtimeType} ${transition.event.runtimeType}: '
      '${transition.currentState.runtimeType} → ${transition.nextState.runtimeType} '
      '| ${transition.nextState?.toString().limit(100)}',
    );
    super.onTransition(bloc, transition);
  }

  @override
  void onError(BlocBase<Object?> bloc, Object error, StackTrace stackTrace) {
    logger.error(
      '${bloc.runtimeType}: $error',
      error: error,
      stackTrace: stackTrace,
    );
    super.onError(bloc, error, stackTrace);
  }
}
