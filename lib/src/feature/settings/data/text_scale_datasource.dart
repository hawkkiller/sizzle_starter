import 'package:sizzle_starter/src/core/utils/preferences_dao.dart';

/// {@template text_scale_datasource}
/// [TextScaleDatasource] is a data source that provides text scale data.
///
/// This is used to set and get text scale.
/// {@endtemplate}
abstract interface class TextScaleDatasource {
  /// Get current text scale from cache
  Future<void> setScale(double scale);

  /// Set text scale
  Future<double?> getScale();
}

/// {@macro text_scale_datasource}
final class TextScaleDatasourceLocal extends PreferencesDao implements TextScaleDatasource {
  /// {@macro text_scale_datasource}
  const TextScaleDatasourceLocal({required super.sharedPreferences});

  PreferencesEntry<double> get _textScale => doubleEntry('settings.textScale');

  @override
  Future<void> setScale(double scale) async => _textScale.set(scale);

  @override
  Future<double?> getScale() async => _textScale.read();
}
