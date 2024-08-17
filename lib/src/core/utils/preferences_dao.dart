import 'package:shared_preferences/shared_preferences.dart';

/// {@template preferences_dao}
/// Class that provides seamless access to the shared preferences.
///
/// Inspired by https://pub.dev/packages/typed_preferences
/// {@endtemplate}
abstract base class PreferencesDao {
  final SharedPreferencesAsync _sharedPreferences;

  /// {@macro preferences_dao}
  const PreferencesDao({required SharedPreferencesAsync sharedPreferences})
      : _sharedPreferences = sharedPreferences;

  /// Obtain [bool] entry from the preferences.
  PreferencesEntry<bool> boolEntry(String key) => TypedEntry<bool>(
        key: key,
        sharedPreferences: _sharedPreferences,
      );

  /// Obtain [double] entry from the preferences.
  PreferencesEntry<double> doubleEntry(String key) => TypedEntry<double>(
        key: key,
        sharedPreferences: _sharedPreferences,
      );

  /// Obtain [int] entry from the preferences.
  PreferencesEntry<int> intEntry(String key) => TypedEntry<int>(
        key: key,
        sharedPreferences: _sharedPreferences,
      );

  /// Obtain [String] entry from the preferences.
  PreferencesEntry<String> stringEntry(String key) => TypedEntry<String>(
        key: key,
        sharedPreferences: _sharedPreferences,
      );

  /// Obtain `List<String>` entry from the preferences.
  PreferencesEntry<List<String>> iterableStringEntry(String key) => TypedEntry<List<String>>(
        key: key,
        sharedPreferences: _sharedPreferences,
      );
}

/// {@template preferences_entry}
/// [PreferencesEntry] describes a single entry in the preferences.
/// This is used to get and set values in the preferences.
/// {@endtemplate}
abstract base class PreferencesEntry<T extends Object> {
  /// {@macro preferences_entry}
  const PreferencesEntry();

  /// The key of the entry in the preferences.
  String get key;

  /// Obtain the value of the entry from the preferences.
  Future<T?> read();

  /// Set the value of the entry in the preferences.
  Future<void> set(T value);

  /// Remove the entry from the preferences.
  Future<void> remove();

  /// Set the value of the entry in the preferences if the value is not null.
  Future<void> setIfNullRemove(T? value) => value == null ? remove() : set(value);
}

/// {@template typed_entry}
/// A [PreferencesEntry] that is typed to a specific type [T].
///
/// You can also create subclasses of this class to create adapters for custom
/// types.
///
/// ```dart
/// class CustomTypeEntry extends TypedEntry<CustomType> {
///  CustomTypeEntry({
///   required SharedPreferences sharedPreferences,
///   required String key,
///  }) : super(sharedPreferences: sharedPreferences, key: key);
///
///  @override
///  CustomType? read() {
///   final value = _sharedPreferences.get(key);
///
///   if (value == null) return null;
///
///   return CustomType.fromJson(value);
///  }
///
///  @override
///  Future<void> set(CustomType value) => _sharedPreferences.setString(
///   key,
///   value.toJson(),
///  );
/// }
/// ```
/// {@endtemplate}
base class TypedEntry<T extends Object> extends PreferencesEntry<T> {
  final SharedPreferencesAsync _sharedPreferences;

  /// {@macro typed_entry}
  const TypedEntry({
    required SharedPreferencesAsync sharedPreferences,
    required this.key,
  }) : _sharedPreferences = sharedPreferences;

  @override
  final String key;

  @override
  Future<T?> read() => switch (T) {
        const (int) => _sharedPreferences.getInt(key) as Future<T?>,
        const (double) => _sharedPreferences.getDouble(key) as Future<T?>,
        const (String) => _sharedPreferences.getString(key) as Future<T?>,
        const (bool) => _sharedPreferences.getBool(key) as Future<T?>,
        const (List<String>) => _sharedPreferences.getStringList(key) as Future<T?>,
        _ => throw StateError('The value of $key is not of type $T'),
      };

  @override
  Future<void> set(T value) => switch (value) {
        final int value => _sharedPreferences.setInt(key, value),
        final double value => _sharedPreferences.setDouble(key, value),
        final String value => _sharedPreferences.setString(key, value),
        final bool value => _sharedPreferences.setBool(key, value),
        final List<String> value => _sharedPreferences.setStringList(key, value),
        _ => throw StateError(
            '$T is not a valid type for a preferences entry value.',
          ),
      };

  @override
  Future<void> remove() => _sharedPreferences.remove(key);
}
