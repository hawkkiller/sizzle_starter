/// Common extensions for [String]
extension StringExtension on String {
  /// Returns a new string with the first [length] characters of this string.
  ///
  /// If [length] is negative the original string is returned. This prevents a
  /// [RangeError] when calling [substring]. When [length] is zero an empty
  /// string is returned.
  String limit(int length) =>
      length < 0 ? this : (length == 0 ? '' : (length < this.length ? substring(0, length) : this));
}
