import 'package:collection/collection.dart';

/// {@template analytics_reporter}
/// Interface for reporting analytics events.
/// {@endtemplate}
abstract interface class AnalyticsReporter {
  /// Logs the provided [event] to analytics.
  Future<void> logEvent(AnalyticsEvent event);
}

/// {@template analytics_event}
/// Event that can be logged to analytics by [AnalyticsReporter].
/// {@endtemplate}
base class AnalyticsEvent {
  /// {@macro analytics_event}
  const AnalyticsEvent(this.name, {this.parameters});

  /// The name of the event.
  final String name;

  /// The parameters of the event.
  final Set<AnalyticsProperty<Object>>? parameters;

  @override
  String toString() {
    final buffer = StringBuffer('AnalyticsEvent(name: $name');
    if (parameters != null) {
      for (final parameter in parameters!) {
        buffer.write(', ${parameter.name}: ${parameter.value}');
      }
    }
    buffer.write(')');
    return buffer.toString();
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AnalyticsEvent &&
        other.name == name &&
        const DeepCollectionEquality().equals(other.parameters, parameters);
  }

  @override
  int get hashCode => name.hashCode ^ const DeepCollectionEquality().hash(parameters);
}

/// {@template analytics_property}
/// A property that can be added to an [AnalyticsEvent].
/// 
/// Currently, there are two types of properties:
/// - [StringAnalyticsProperty]
/// - [NumberAnalyticsProperty]
/// 
/// Other types are not supported by Firebase Analytics. If you are using a
/// different tool for analytics, you can create a custom property type.
/// {@endtemplate}
sealed class AnalyticsProperty<T> {
  /// {@macro analytics_property}
  const AnalyticsProperty(this.name, this.value);

  /// The name of the property.
  final String name;

  /// The value of the property.
  final T value;
}

/// {@template string_analytics_property}
/// Analytics property that contains a [String] value.
/// {@endtemplate}
final class StringAnalyticsProperty extends AnalyticsProperty<String> {
  /// {@macro string_analytics_property}
  const StringAnalyticsProperty(super.name, super.value);

  @override
  String toString() => 'StringAnalyticsProperty(name: $name, value: $value)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is StringAnalyticsProperty && other.name == name && other.value == value;
  }

  @override
  int get hashCode => name.hashCode ^ value.hashCode;
}

/// {@template number_analytics_property}
/// Analytics property that contains a [num] value.
/// {@endtemplate}
final class NumberAnalyticsProperty extends AnalyticsProperty<num> {
  /// {@macro number_analytics_property}
  const NumberAnalyticsProperty(super.name, super.value);

  @override
  String toString() => 'NumberAnalyticsProperty(name: $name, value: $value)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is NumberAnalyticsProperty && other.name == name && other.value == value;
  }

  @override
  int get hashCode => name.hashCode ^ value.hashCode;
}
