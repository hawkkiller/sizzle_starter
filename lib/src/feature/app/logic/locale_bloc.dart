import 'dart:ui';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sizzle_starter/src/core/utils/logger.dart';
import 'package:sizzle_starter/src/feature/app/data/locale_repository.dart';

part 'locale_bloc.freezed.dart';

/// Locale event for [LocaleBloc]
@freezed
sealed class LocaleEvent with _$LocaleEvent {
  /// Updates the locale with the given [locale].
  const factory LocaleEvent.update({required Locale locale}) =
      _LocaleEventUpdate;
}

/// Locale state for [LocaleBloc]
@freezed
sealed class LocaleState with _$LocaleState {
  /// Initial state of the locale bloc.
  const factory LocaleState.idle({Locale? locale}) = _LocaleStateIdle;

  /// State when the locale is being updated.
  const factory LocaleState.inProgress({required Locale locale}) =
      _LocaleStateInProgress;
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
  LocaleBloc({required LocaleRepository localeRepository})
      : _localeRepository = localeRepository,
        super(
          LocaleState.idle(
            locale:
                localeRepository.loadLocaleFromCache() ?? const Locale('en'),
          ),
        ) {
    on<LocaleEvent>(
      (event, emit) => event.map(update: (e) => _update(e, emit)),
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
