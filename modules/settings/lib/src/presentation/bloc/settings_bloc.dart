import 'package:bloc/bloc.dart';
import 'package:settings/settings.dart';
import 'package:settings/src/domain/repositories/settings_repository.dart';

final class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc({
    required SettingsRepository settingsRepository,
    required SettingsState initialState,
  }) : _settingsRepository = settingsRepository,
       super(initialState) {
    on<SettingsEvent>(
      (event, emit) => switch (event) {
        final SettingsEventUpdate e => _updateSettings(e, emit),
      },
    );
  }

  final SettingsRepository _settingsRepository;

  Future<void> _updateSettings(
    SettingsEventUpdate event,
    Emitter<SettingsState> emit,
  ) async {
    try {
      emit(SettingsStateProcessing(settings: state.settings));
      await _settingsRepository.saveSettings(event.settings);
      emit(SettingsStateIdle(settings: event.settings));
    } catch (error, stackTrace) {
      emit(SettingsStateError(settings: event.settings, error: error));
      onError(error, stackTrace);
    }
  }
}

/// States for the [SettingsBloc].
sealed class SettingsState {
  const SettingsState({this.settings});

  /// Application locale.
  final Settings? settings;
}

final class SettingsStateIdle extends SettingsState {
  const SettingsStateIdle({super.settings});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SettingsStateIdle && other.settings == settings;
  }

  @override
  int get hashCode => settings.hashCode;

  @override
  String toString() => 'SettingsState.idle(settings: $settings)';
}

final class SettingsStateProcessing extends SettingsState {
  const SettingsStateProcessing({super.settings});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SettingsStateProcessing && other.settings == settings;
  }

  @override
  int get hashCode => settings.hashCode;

  @override
  String toString() => 'SettingsState.loading(settings: $settings)';
}

final class SettingsStateError extends SettingsState {
  const SettingsStateError({required this.error, super.settings});

  /// The error.
  final Object error;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SettingsStateError && other.settings == settings && other.error == error;
  }

  @override
  int get hashCode => Object.hash(settings, error);

  @override
  String toString() => 'SettingsState.error(settings: $settings, error: $error)';
}

/// Events for the [SettingsBloc].
sealed class SettingsEvent {
  const SettingsEvent();
}

final class SettingsEventUpdate extends SettingsEvent {
  const SettingsEventUpdate({required this.settings});

  /// The theme to update.
  final Settings settings;

  @override
  String toString() => 'SettingsEvent.updatesettings(settings: $settings)';
}
