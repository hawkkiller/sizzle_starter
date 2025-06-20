import 'package:bloc/bloc.dart';
import 'package:settings_api/settings_api.dart';

/// A [Bloc] that handles [Settings].
final class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc({
    required SettingsRepository settingsRepository,
    required SettingsState initialState,
  }) : _settingsRepository = settingsRepository,
       super(initialState) {
    on<SettingsEvent>(
      (event, emit) => switch (event) {
        final _UpdateSettingsEvent e => _updateSettings(e, emit),
      },
    );
  }

  final SettingsRepository _settingsRepository;

  Future<void> _updateSettings(
    _UpdateSettingsEvent event,
    Emitter<SettingsState> emit,
  ) async {
    try {
      emit(_LoadingSettingsState(settings: state.settings));
      await _settingsRepository.save(event.settings);
      emit(_IdleSettingsState(settings: event.settings));
    } catch (error) {
      emit(_ErrorSettingsState(settings: event.settings, error: error));
    }
  }
}

/// States for the [SettingsBloc].
sealed class SettingsState {
  const SettingsState({this.settings});

  /// lication locale.
  final Settings? settings;

  /// The  settings are idle.
  const factory SettingsState.idle({Settings? settings}) = _IdleSettingsState;

  /// The  settings are loading.
  const factory SettingsState.loading({Settings? settings}) = _LoadingSettingsState;

  /// The  settings have an error.
  const factory SettingsState.error({required Object error, Settings? settings}) =
      _ErrorSettingsState;
}

final class _IdleSettingsState extends SettingsState {
  const _IdleSettingsState({super.settings});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is _IdleSettingsState && other.settings == settings;
  }

  @override
  int get hashCode => settings.hashCode;

  @override
  String toString() => 'SettingsState.idle(settings: $settings)';
}

final class _LoadingSettingsState extends SettingsState {
  const _LoadingSettingsState({super.settings});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is _LoadingSettingsState && other.settings == settings;
  }

  @override
  int get hashCode => settings.hashCode;

  @override
  String toString() => 'SettingsState.loading(settings: $settings)';
}

final class _ErrorSettingsState extends SettingsState {
  const _ErrorSettingsState({required this.error, super.settings});

  /// The error.
  final Object error;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is _ErrorSettingsState && other.settings == settings && other.error == error;
  }

  @override
  int get hashCode => Object.hash(settings, error);

  @override
  String toString() => 'SettingsState.error(settings: $settings, error: $error)';
}

/// Events for the [SettingsBloc].
sealed class SettingsEvent {
  const SettingsEvent();

  /// Update the  settings.
  const factory SettingsEvent.updateSettings({required Settings settings}) = _UpdateSettingsEvent;
}

final class _UpdateSettingsEvent extends SettingsEvent {
  const _UpdateSettingsEvent({required this.settings});

  /// The theme to update.
  final Settings settings;

  @override
  String toString() => 'SettingsEvent.updateSettings(settings: $settings)';
}
