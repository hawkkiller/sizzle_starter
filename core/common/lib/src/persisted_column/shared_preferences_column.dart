import 'dart:convert';

import 'package:common/common.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// [SharedPreferencesColumn] describes a single persisted entry in [SharedPreferences].
abstract base class SharedPreferencesColumn<T extends Object> extends PersistedColumn<T> {
  const SharedPreferencesColumn({required this.sharedPreferences, required this.key});

  /// The instance of [SharedPreferences] used to read and write values.
  final SharedPreferencesAsync sharedPreferences;

  /// The key used to store the value in the cache.
  final String key;

  @override
  Future<void> remove() async {
    await sharedPreferences.remove(key);
  }
}

/// A [int] implementation of [SharedPreferencesColumn].
final class SharedPreferencesColumnInteger extends SharedPreferencesColumn<int> {
  const SharedPreferencesColumnInteger({required super.sharedPreferences, required super.key});

  @override
  Future<int?> read() => sharedPreferences.getInt(key);

  @override
  Future<void> set(int value) async {
    await sharedPreferences.setInt(key, value);
  }
}

/// A [String] implementation of [SharedPreferencesColumn].
final class SharedPreferencesColumnString extends SharedPreferencesColumn<String> {
  /// {@macro string_preferences_entry}
  const SharedPreferencesColumnString({
    required super.sharedPreferences,
    required super.key,
  });

  @override
  Future<String?> read() => sharedPreferences.getString(key);

  @override
  Future<void> set(String value) async {
    await sharedPreferences.setString(key, value);
  }
}

/// A [bool] implementation of [SharedPreferencesColumn].
final class SharedPreferencesColumnBoolean extends SharedPreferencesColumn<bool> {
  const SharedPreferencesColumnBoolean({
    required super.sharedPreferences,
    required super.key,
  });

  @override
  Future<bool?> read() => sharedPreferences.getBool(key);

  @override
  Future<void> set(bool value) async {
    await sharedPreferences.setBool(key, value);
  }
}

/// A [double] implementation of [SharedPreferencesColumn].
final class SharedPreferencesColumnDouble extends SharedPreferencesColumn<double> {
  const SharedPreferencesColumnDouble({
    required super.sharedPreferences,
    required super.key,
  });

  @override
  Future<double?> read() => sharedPreferences.getDouble(key);

  @override
  Future<void> set(double value) async {
    await sharedPreferences.setDouble(key, value);
  }
}

/// A [List<String>] implementation of [SharedPreferencesColumn].
final class SharedPreferencesColumnStringList extends SharedPreferencesColumn<List<String>> {
  const SharedPreferencesColumnStringList({
    required super.sharedPreferences,
    required super.key,
  });

  @override
  Future<List<String>?> read() => sharedPreferences.getStringList(key);

  @override
  Future<void> set(List<String> value) async {
    await sharedPreferences.setStringList(key, value);
  }
}

final class SharedPreferencesColumnJson extends SharedPreferencesColumn<Map<String, Object?>> {
  const SharedPreferencesColumnJson({
    required super.sharedPreferences,
    required super.key,
  });

  @override
  Future<Map<String, Object?>?> read() async {
    final jsonString = await sharedPreferences.getString(key);
    if (jsonString == null) {
      return null;
    }

    final decoded = jsonDecode(jsonString);

    if (decoded is Map<String, Object?>) {
      return decoded;
    }

    throw const FormatException('Stored value is not a JSON object');
  }

  @override
  Future<void> set(Map<String, Object?> value) async {
    final jsonString = jsonEncode(value);

    await sharedPreferences.setString(key, jsonString);
  }
}
