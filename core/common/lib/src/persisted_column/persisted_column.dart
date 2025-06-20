/// [PersistedColumn] describes a single persisted column.
abstract base class PersistedColumn<T extends Object> {
  const PersistedColumn();

  /// Read the value
  Future<T?> read();

  /// Set the value
  Future<void> set(T value);

  /// Remove the value
  Future<void> remove();

  /// Set the value if the value is not null, otherwise remove the value
  Future<void> setIfNullRemove(T? value) => value == null ? remove() : set(value);
}
