import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizzle_starter/src/feature/settings/data/app_settings_repository.dart';
import 'package:sizzle_starter/src/feature/settings/model/app_settings.dart';

/// {@template app_settings_bloc}
/// A [Bloc] that handles [AppSettings].
/// {@endtemplate}
final class AppSettingsBloc extends Bloc<AppSettingsEvent, AppSettingsState> {
  /// {@macro app_settings_bloc}
  AppSettingsBloc({
    required AppSettingsRepository appSettingsRepository,
    required AppSettingsState initialState,
  })  : _appSettingsRepository = appSettingsRepository,
        super(initialState) {
    on<AppSettingsEvent>(
      (event, emit) => switch (event) {
        final _UpdateAppSettingsEvent e => _updateAppSettings(e, emit),
      },
    );
  }

  final AppSettingsRepository _appSettingsRepository;

  Future<void> _updateAppSettings(
    _UpdateAppSettingsEvent event,
    Emitter<AppSettingsState> emit,
  ) async {
    try {
      emit(_LoadingAppSettingsState(appSettings: state.appSettings));
      await _appSettingsRepository.setAppSettings(event.appSettings);
      emit(_IdleAppSettingsState(appSettings: event.appSettings));
    } catch (error) {
      emit(_ErrorAppSettingsState(appSettings: event.appSettings, error: error));
    }
  }
}

/// States for the [AppSettingsBloc].
sealed class AppSettingsState {
  const AppSettingsState({this.appSettings});

  /// Application locale.
  final AppSettings? appSettings;

  /// The app settings are idle.
  const factory AppSettingsState.idle({AppSettings? appSettings}) = _IdleAppSettingsState;

  /// The app settings are loading.
  const factory AppSettingsState.loading({AppSettings? appSettings}) = _LoadingAppSettingsState;

  /// The app settings have an error.
  const factory AppSettingsState.error({
    required Object error,
    AppSettings? appSettings,
  }) = _ErrorAppSettingsState;
}

final class _IdleAppSettingsState extends AppSettingsState {
  const _IdleAppSettingsState({super.appSettings});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is _IdleAppSettingsState && other.appSettings == appSettings;
  }

  @override
  int get hashCode => appSettings.hashCode;

  @override
  String toString() => 'SettingsState.idle(appSettings: $appSettings)';
}

final class _LoadingAppSettingsState extends AppSettingsState {
  const _LoadingAppSettingsState({super.appSettings});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is _LoadingAppSettingsState && other.appSettings == appSettings;
  }

  @override
  int get hashCode => appSettings.hashCode;

  @override
  String toString() => 'SettingsState.loading(appSettings: $appSettings)';
}

final class _ErrorAppSettingsState extends AppSettingsState {
  const _ErrorAppSettingsState({required this.error, super.appSettings});

  /// The error.
  final Object error;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is _ErrorAppSettingsState &&
        other.appSettings == appSettings &&
        other.error == error;
  }

  @override
  int get hashCode => Object.hash(appSettings, error);

  @override
  String toString() => 'SettingsState.error(appSettings: $appSettings, error: $error)';
}

/// Events for the [AppSettingsBloc].
sealed class AppSettingsEvent {
  const AppSettingsEvent();

  /// Update the app settings.
  const factory AppSettingsEvent.updateAppSettings({
    required AppSettings appSettings,
  }) = _UpdateAppSettingsEvent;
}

final class _UpdateAppSettingsEvent extends AppSettingsEvent {
  const _UpdateAppSettingsEvent({required this.appSettings});

  /// The theme to update.
  final AppSettings appSettings;

  @override
  String toString() => 'SettingsEvent.updateAppSettings(appSettings: $appSettings)';
}
