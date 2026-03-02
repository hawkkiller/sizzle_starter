import 'package:flutter_bloc/flutter_bloc.dart';

Stream<Event> sequentialBlocTransformer<Event>(Stream<Event> stream, EventMapper<Event> mapper) =>
    stream.asyncExpand(mapper);
