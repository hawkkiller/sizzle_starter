import 'dart:async';

import 'package:drift/drift.dart';
import 'package:drift/wasm.dart';

/// {@macro db_executor}
FutureOr<QueryExecutor> createExecutor(String name) async {
  final result = await WasmDatabase.open(
    databaseName: name,
    sqlite3Uri: Uri.parse('/sqlite3.wasm'),
    driftWorkerUri: Uri.parse('/drift_worker.dart.js'),
  );
  return result.resolvedExecutor;
}
