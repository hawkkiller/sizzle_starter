import 'package:flutter/widgets.dart';

mixin PageStorageReader<T extends StatefulWidget, K> on State<T> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final data = readStoredData();

      if (data case final data?) restoreState(data);
    });
  }

  Object? obtainPageStorageIdentifier();

  void restoreState(K data) {}

  K? readStoredData([BuildContext? context]) {
    final ctx = context ?? this.context;
    final identifier = obtainPageStorageIdentifier();

    final data = PageStorage.maybeOf(ctx)?.readState(ctx, identifier: identifier);

    return data as K?;
  }

  void writeStoredData(K data, [BuildContext? context]) {
    final ctx = context ?? this.context;
    final identifier = obtainPageStorageIdentifier();

    PageStorage.maybeOf(ctx)?.writeState(ctx, data, identifier: identifier);
  }
}
