import 'package:sizzle_starter/src/feature/settings/data/text_scale_datasource.dart';

/// Theme repository that persists and retrieves text scale informarion
abstract interface class TextScaleRepository {
  Future<double?> getScale();

  Future<void> setScale(double locale);
}

/// Text scale repository implementation
final class TextScaleRepositoryImpl implements TextScaleRepository {
  /// Create text scale repository
  const TextScaleRepositoryImpl(
      {required TextScaleDatasource textScaleDataSource})
      : _textScaleDataSource = textScaleDataSource;

  final TextScaleDatasource _textScaleDataSource;

  @override
  Future<double?> getScale() => _textScaleDataSource.getScale();

  @override
  Future<void> setScale(double scale) => _textScaleDataSource.setScale(scale);
}
