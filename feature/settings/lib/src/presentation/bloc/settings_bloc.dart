import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:settings/settings.dart';

sealed class SettingsEvent {
  const SettingsEvent();
}

final class SettingsEventUpdate extends SettingsEvent {
  const SettingsEventUpdate({required this.onUpdate});

  final Settings Function(Settings settings) onUpdate;
}

sealed class SettingsState {
  const SettingsState({required this.data});

  final Settings data;
}

final class SettingsStateIdle extends SettingsState {
  const SettingsStateIdle({required super.data});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SettingsStateIdle && other.data == data;
  }

  @override
  int get hashCode => data.hashCode;
}

final class SettingsStateLoading extends SettingsState {
  const SettingsStateLoading({required super.data});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SettingsStateLoading && other.data == data;
  }

  @override
  int get hashCode => data.hashCode;
}

final class SettingsStateError extends SettingsState {
  const SettingsStateError({required super.data, required this.error});

  final Object error;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SettingsStateError && other.data == data && other.error == error;
  }

  @override
  int get hashCode => data.hashCode ^ error.hashCode;
}

final class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc({required this.settingsRepository})
    : super(SettingsStateIdle(data: settingsRepository.current)) {
    on<SettingsEventUpdate>(_onUpdate);

    _settingsSubscription = settingsRepository.watch().listen(_onSettingsChanged);
  }

  final SettingsRepository settingsRepository;
  StreamSubscription<void>? _settingsSubscription;

  @override
  Future<void> close() async {
    await _settingsSubscription?.cancel();
    return super.close();
  }

  void _onSettingsChanged(Settings settings) {
    if (settings != state.data) {
      // ignore: invalid_use_of_visible_for_testing_member
      emit(SettingsStateIdle(data: settings));
    }
  }

  Future<void> _onUpdate(
    SettingsEventUpdate event,
    Emitter<SettingsState> emit,
  ) async {
    emit(SettingsStateLoading(data: state.data));
    try {
      final newSettings = await settingsRepository.save(event.onUpdate);
      emit(SettingsStateIdle(data: newSettings));
    } on Object catch (error, stackTrace) {
      emit(SettingsStateError(data: state.data, error: error));
      emit(SettingsStateIdle(data: state.data));

      onError(error, stackTrace);
    }
  }
}
