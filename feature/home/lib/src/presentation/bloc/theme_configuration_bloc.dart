import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:settings_api/settings_api.dart';

sealed class ThemeConfigurationEvent {
  const ThemeConfigurationEvent();
}

final class ThemeConfigurationEventUpdate extends ThemeConfigurationEvent {
  const ThemeConfigurationEventUpdate({required this.onUpdate});

  final ThemeConfiguration Function(ThemeConfiguration configuration) onUpdate;
}

sealed class ThemeConfigurationState {
  const ThemeConfigurationState({required this.configuration});

  final ThemeConfiguration configuration;
}

final class ThemeConfigurationStateIdle extends ThemeConfigurationState {
  const ThemeConfigurationStateIdle({required super.configuration});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ThemeConfigurationStateIdle && other.configuration == configuration;
  }

  @override
  int get hashCode => configuration.hashCode;
}

final class ThemeConfigurationStateLoading extends ThemeConfigurationState {
  const ThemeConfigurationStateLoading({required super.configuration});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ThemeConfigurationStateLoading && other.configuration == configuration;
  }

  @override
  int get hashCode => configuration.hashCode;
}

final class ThemeConfigurationStateError extends ThemeConfigurationState {
  const ThemeConfigurationStateError({required super.configuration, required this.error});

  final Object error;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ThemeConfigurationStateError &&
        other.configuration == configuration &&
        other.error == error;
  }

  @override
  int get hashCode => configuration.hashCode ^ error.hashCode;
}

final class ThemeConfigurationBloc extends Bloc<ThemeConfigurationEvent, ThemeConfigurationState> {
  ThemeConfigurationBloc({required this.settingsRepository})
    : super(
        ThemeConfigurationStateIdle(configuration: settingsRepository.current.themeConfiguration),
      ) {
    on<ThemeConfigurationEventUpdate>(_onUpdate);
  }

  final SettingsRepository settingsRepository;

  Future<void> _onUpdate(
    ThemeConfigurationEventUpdate event,
    Emitter<ThemeConfigurationState> emit,
  ) async {
    emit(ThemeConfigurationStateLoading(configuration: state.configuration));
    try {
      final newSettings = await settingsRepository.save(
        (settings) => settings.copyWith(
          themeConfiguration: event.onUpdate(settings.themeConfiguration),
        ),
      );
      emit(ThemeConfigurationStateIdle(configuration: newSettings.themeConfiguration));
    } catch (error) {
      emit(ThemeConfigurationStateError(configuration: state.configuration, error: error));
      emit(ThemeConfigurationStateIdle(configuration: state.configuration));
    }
  }
}
