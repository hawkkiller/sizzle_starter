import 'package:collection/collection.dart';
import 'package:sizzle_starter/src/core/utils/analytics/firebase_analytics_reporter.dart';

/// {@template analytics_reporter}
/// Interface for reporting analytics events.
///
/// This interface should be implemented to report [AnalyticsEvent]s to the
/// analytics service being used by the application.
///
/// See implementations of this interface:
/// - [FirebaseAnalyticsReporter]
/// {@endtemplate}
abstract interface class AnalyticsReporter {
  /// Logs the provided [event] to analytics.
  ///
  /// This method should be implemented to report the event to the analytics
  /// service being used by the application.
  ///
  /// The [event] should be logged to the analytics service as-is, including any
  /// parameters that are included with the event.
  Future<void> logEvent(AnalyticsEvent event);
}

/// {@template analytics_event}
/// Represents an event that can be logged to analytics by [AnalyticsReporter].
///
/// This class can be used to track user interactions, screen views, or other
/// significant actions within the application.
///
/// It is recommended to create custom events by extending this class, although
/// events can also be added directly using this class.
/// {@endtemplate}
base class AnalyticsEvent {
  /// {@macro analytics_event}
  const AnalyticsEvent(this.name, {this.parameters});

  /// The name of the event.
  ///
  /// It should be a unique identifier for the event that is understood by the
  /// analytics service being used.
  final String name;

  /// The parameters of the event.
  ///
  /// Parameters are optional and can be used to provide additional context or
  /// data with the event.
  final Set<AnalyticsParameter<Object>>? parameters;

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

/// {@template analytics_parameter}
/// A parameter that can be added to an [AnalyticsEvent].
///
/// Currently, there are two types of parameters:
/// - [StringAnalyticsParameter]
/// - [NumberAnalyticsParameter]
///
/// Other types are not supported by Firebase Analytics. If you are using a
/// different tool for analytics, you can create a custom parameter type.
/// {@endtemplate}
sealed class AnalyticsParameter<T> {
  /// {@macro analytics_parameter}
  const AnalyticsParameter(this.name, this.value);

  /// The name of the parameter.
  final String name;

  /// The value of the parameter.
  final T value;
}

/// {@template string_analytics_parameter}
/// Analytics parameter that contains a [String] value.
/// {@endtemplate}
final class StringAnalyticsParameter extends AnalyticsParameter<String> {
  /// {@macro string_analytics_parameter}
  const StringAnalyticsParameter(super.name, super.value);

  @override
  String toString() => 'StringAnalyticsParameter(name: $name, value: $value)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is StringAnalyticsParameter && other.name == name && other.value == value;
  }

  @override
  int get hashCode => name.hashCode ^ value.hashCode;
}

/// {@template number_analytics_parameter}
/// Analytics parameter that contains a [num] value.
/// {@endtemplate}
final class NumberAnalyticsParameter extends AnalyticsParameter<num> {
  /// {@macro number_analytics_parameter}
  const NumberAnalyticsParameter(super.name, super.value);

  @override
  String toString() => 'NumberAnalyticsParameter(name: $name, value: $value)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is NumberAnalyticsParameter && other.name == name && other.value == value;
  }

  @override
  int get hashCode => name.hashCode ^ value.hashCode;
}
