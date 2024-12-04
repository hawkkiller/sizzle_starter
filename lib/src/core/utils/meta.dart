/// {@template throws}
/// An annotation to specify the exceptions that a method can throw.
/// {@endtemplate}
class Throws {
  /// Creates a new Throws annotation.
  const Throws(this.exceptions);

  /// The exceptions that a method can throw.
  final Set<Type> exceptions;
}
