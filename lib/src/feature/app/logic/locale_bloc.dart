import 'dart:ui';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:sizzle_starter/src/core/utils/logger.dart';
import 'package:sizzle_starter/src/core/utils/pattern_match.dart';
import 'package:sizzle_starter/src/feature/app/data/locale_repository.dart';

/// {@template locale_state}
/// Locale state
/// {@endtemplate}
@immutable
sealed class LocaleState extends _LocaleStateBase {
  /// {@macro locale_state}
  const LocaleState();

  /// The state machine is idling (i.e. doing nothing)
  const factory LocaleState.idle({
    required Locale locale,
  }) = _LocaleStateIdle;

  /// The state machine is in progress (i.e. doing something)
  const factory LocaleState.inProgress({
    required Locale locale,
  }) = _LocaleStateInProgress;
}

/// {@macro locale_state}
///
/// This state is used when the
/// state machine is idling (i.e. doing nothing)
final class _LocaleStateIdle extends LocaleState {
  const _LocaleStateIdle({
    required this.locale,
  });

  @override
  final Locale locale;

  @override
  String toString() => 'LocaleState.idle(locale: $locale)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is _LocaleStateIdle && locale == other.locale);

  @override
  int get hashCode => locale.hashCode;
}

/// {@macro locale_state}
///
/// This state is used when the
/// state machine is in progress (i.e. doing something)
final class _LocaleStateInProgress extends LocaleState {
  const _LocaleStateInProgress({
    required this.locale,
  });

  @override
  final Locale locale;

  @override
  String toString() => 'LocaleState.inProgress()';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is _LocaleStateInProgress && locale == other.locale);

  @override
  int get hashCode => locale.hashCode;
}

abstract base class _LocaleStateBase {
  const _LocaleStateBase();

  /// The current locale in state
  Locale get locale;

  T map<T>({
    required PatternMatch<T, _LocaleStateIdle> idle,
    required PatternMatch<T, _LocaleStateInProgress> inProgress,
  }) =>
      switch (this) {
        final _LocaleStateIdle state => idle(state),
        final _LocaleStateInProgress state => inProgress(state),
        _ => throw AssertionError('Unknown state: $this'),
      };

  T maybeMap<T>({
    required PatternMatch<T, _LocaleStateIdle>? idle,
    required PatternMatch<T, _LocaleStateInProgress>? inProgress,
    required T orElse,
  }) =>
      map(
        idle: idle ?? (_) => orElse,
        inProgress: inProgress ?? (_) => orElse,
      );
}

/// Sealed class representing events that can be sent to the [LocaleBloc].
///
/// Extends [_LocaleEventBase] to provide a common base class for all events.
///
/// Provides a single event, [LocaleEvent.update], which is used to update the
/// app's locale with the given [Locale].
@immutable
sealed class LocaleEvent extends _LocaleEventBase {
  /// Creates a new [LocaleEvent].
  ///
  /// Provides a common base class for all events that can be sent to the
  /// [LocaleBloc].
  const LocaleEvent();

  /// Updates the app's locale with the given [Locale].
  const factory LocaleEvent.update(Locale locale) = _LocaleEventUpdate;
}

/// This event is used when the
/// locale is updated
final class _LocaleEventUpdate extends LocaleEvent {
  const _LocaleEventUpdate(this.locale);

  /// The new locale
  final Locale locale;

  @override
  String toString() => 'LocaleEvent.update(locale: $locale)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is _LocaleEventUpdate && locale == other.locale);

  @override
  int get hashCode => locale.hashCode;
}

abstract base class _LocaleEventBase {
  const _LocaleEventBase();

  T map<T>({
    required PatternMatch<T, _LocaleEventUpdate> update,
  }) =>
      switch (this) {
        final _LocaleEventUpdate event => update(event),
        _ => throw AssertionError('Unknown event: $this'),
      };

  T maybeMap<T>({
    required PatternMatch<T, _LocaleEventUpdate>? update,
    required T orElse,
  }) =>
      map(
        update: update ?? (_) => orElse,
      );
}

/// Business Logic Component (BLoC) for managing the app's locale.
///
/// Emits a [LocaleState] to represent the current locale state of the app.
/// Responds to [LocaleEvent]s to update the locale state.
class LocaleBloc extends Bloc<LocaleEvent, LocaleState> {
  final LocaleRepository _localeRepository;

  /// Creates a new [LocaleBloc] with the given [LocaleRepository].
  ///
  /// The initial state is set to [LocaleState.idle] with the locale loaded from
  /// the cache, or the default locale of 'en' if no
  /// locale is found in the cache.
  ///
  /// Responds to [LocaleEvent.update] events by calling [_update] to update the
  /// locale state.
  LocaleBloc({
    required LocaleRepository localeRepository,
  })  : _localeRepository = localeRepository,
        super(
          LocaleState.idle(
            locale:
                localeRepository.loadLocaleFromCache() ?? const Locale('en'),
          ),
        ) {
    on<LocaleEvent>(
      (event, emit) => event.map(
        update: (e) => _update(e, emit),
      ),
    );
  }

  /// Updates the current locale with the new locale from the given event.
  ///
  /// Emits a [LocaleState.inProgress] state with a default locale of 'en'
  /// before calling [LocaleRepository.setLocale] to update the locale. If the
  /// update is successful, emits a [LocaleState.idle] state with the new locale
  ///
  /// If there is an error during the update, logs a warning message with the
  /// error and emits a [LocaleState.idle] state with default locale of 'en'.
  ///
  /// Throws any error that occurs during the update.
  Future<void> _update(
    _LocaleEventUpdate event,
    Emitter<LocaleState> emit,
  ) async {
    try {
      emit(const LocaleState.inProgress(locale: Locale('en')));
      await _localeRepository.setLocale(event.locale);
      emit(LocaleState.idle(locale: event.locale));
    } on Object catch (e) {
      logger.warning('Failed to update locale, $e');
      emit(const LocaleState.idle(locale: Locale('en')));
      rethrow;
    }
  }
}
