import 'package:flutter_bloc/flutter_bloc.dart';

/// A function that maps an event of type [Event] to a stream of events.
abstract base class BlocTransformer<Event> {
  /// Transforms the given [stream] of events.
  Stream<Event> transform(Stream<Event> stream, EventMapper<Event> mapper);
}

/// Sequentially maps events to a stream of events.
final class SequentialBlocTransformer<Event> extends BlocTransformer<Event> {
  @override
  Stream<Event> transform(Stream<Event> stream, EventMapper<Event> mapper) =>
      stream.asyncExpand(mapper);
}
