extension StringExtension on String {
  String limit(int length) => length < this.length ? substring(0, length) : this;
}
