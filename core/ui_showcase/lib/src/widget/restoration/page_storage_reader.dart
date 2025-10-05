import 'package:flutter/widgets.dart';
import 'package:ui_showcase/src/widget/inputs/input_widget.dart';

mixin PageStorageReader<T extends InputWidget, K> on State<T> {
  @override
  void initState() {
    super.initState();
    widget.listenable.addListener(_onListenableChanged);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final data = readStoredData();

      if (data case final data?) restoreState(data);
    });
  }

  @override
  void dispose() {
    widget.listenable.removeListener(_onListenableChanged);
    super.dispose();
  }

  K getCurrentValue();

  Object? obtainPageStorageIdentifier();

  K? readStoredData([BuildContext? context]) {
    final ctx = context ?? this.context;
    final identifier = obtainPageStorageIdentifier();

    final data = PageStorage.maybeOf(ctx)?.readState(ctx, identifier: identifier);

    return data as K?;
  }

  void restoreState(K data) {}

  void writeStoredData(K data, [BuildContext? context]) {
    final ctx = context ?? this.context;
    final identifier = obtainPageStorageIdentifier();

    PageStorage.maybeOf(ctx)?.writeState(ctx, data, identifier: identifier);
  }

  void _onListenableChanged() {
    final data = getCurrentValue();
    writeStoredData(data);
  }
}
