import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:sizzle_starter/src/core/utils/logger.dart';
import 'package:sizzle_starter/src/core/utils/pattern_match.dart';
import 'package:sizzle_starter/src/feature/app/data/theme_repository.dart';
import 'package:sizzle_starter/src/feature/app/model/app_theme.dart';
import 'package:sizzle_starter/src/feature/app/widget/theme_scope.dart';

/// {@template theme_event}
/// Theme event
/// {@endtemplate}
@immutable
sealed class ThemeEvent with _ThemeEvent {
  /// {@macro theme_event}
  const ThemeEvent();

  /// Update the theme
  const factory ThemeEvent.update(AppTheme theme) = _ThemeEventUpdate;
}

final class _ThemeEventUpdate extends ThemeEvent {
  final AppTheme theme;

  const _ThemeEventUpdate(this.theme);

  @override
  String toString() => 'ThemeEvent.update(theme: $theme)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is _ThemeEventUpdate &&
          runtimeType == other.runtimeType &&
          theme == other.theme);

  @override
  int get hashCode => theme.hashCode;
}

abstract base mixin class _ThemeEvent {
  const _ThemeEvent();

  T map<T>({
    required PatternMatch<T, _ThemeEventUpdate> update,
  }) =>
      switch (this) {
        final _ThemeEventUpdate event => update(event),
        _ => throw AssertionError('Unknown event: $this'),
      };

  T maybeMap<T>({
    required PatternMatch<T, _ThemeEventUpdate>? update,
    required T orElse,
  }) =>
      map(
        update: update ?? (_) => orElse,
      );
}

/// {@template theme_state}
/// Theme state
/// {@endtemplate}
@immutable
sealed class ThemeState with _ThemeState {
  /// {@macro theme_state}
  const ThemeState();

  /// Idle state
  const factory ThemeState.idle(AppTheme theme) = _ThemeStateIdle;

  /// In Progress state
  const factory ThemeState.inProgress(AppTheme theme) = _ThemeStateInProgress;
}

final class _ThemeStateIdle extends ThemeState {
  @override
  final AppTheme theme;

  const _ThemeStateIdle(this.theme);

  @override
  String toString() => 'ThemeState.idle(theme: $theme)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is _ThemeStateIdle &&
          runtimeType == other.runtimeType &&
          theme == other.theme);

  @override
  int get hashCode => theme.hashCode;
}

final class _ThemeStateInProgress extends ThemeState {
  @override
  final AppTheme theme;

  const _ThemeStateInProgress(this.theme);

  @override
  String toString() => 'ThemeState.inProgress(theme: $theme)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is _ThemeStateInProgress &&
          runtimeType == other.runtimeType &&
          theme == other.theme);

  @override
  int get hashCode => theme.hashCode;
}

abstract base mixin class _ThemeState {
  const _ThemeState();

  /// Current theme
  AppTheme get theme;

  T map<T>({
    required PatternMatch<T, _ThemeStateIdle> idle,
    required PatternMatch<T, _ThemeStateInProgress> inProgress,
  }) =>
      switch (this) {
        final _ThemeStateIdle state => idle(state),
        final _ThemeStateInProgress state => inProgress(state),
        _ => throw AssertionError('Unknown state: $this'),
      };

  T maybeMap<T>({
    required PatternMatch<T, _ThemeStateIdle>? idle,
    required PatternMatch<T, _ThemeStateInProgress>? inProgress,
    required T orElse,
  }) =>
      map(
        idle: idle ?? (_) => orElse,
        inProgress: inProgress ?? (_) => orElse,
      );
}

/// {@template theme_bloc}
/// Business logic components that can switch themes.
///
/// It communicates with provided repository to persist the theme.
///
/// Should not be used directly, instead use [ThemeScope].
/// It operates ThemeBloc under the hood.
/// {@endtemplate}
final class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  final ThemeRepository _themeRepository;

  /// {@macro theme_bloc}
  ThemeBloc(this._themeRepository)
      : super(
          ThemeState.idle(
            _themeRepository.loadAppThemeFromCache() ?? AppTheme.system,
          ),
        ) {
    on<ThemeEvent>(
      (event, emit) => event.map(
        update: (e) => _update(e, emit),
      ),
    );
  }

  Future<void> _update(
    _ThemeEventUpdate event,
    Emitter<ThemeState> emit,
  ) async {
    final oldTheme = state.theme;
    try {
      emit(ThemeState.inProgress(event.theme));
      await _themeRepository.setTheme(event.theme);
      emit(ThemeState.idle(event.theme));
    } catch (e) {
      logger.warning(
        'Failed to update theme to $event, reverting to $oldTheme',
      );
      emit(ThemeState.idle(oldTheme));
      rethrow;
    }
  }
}
