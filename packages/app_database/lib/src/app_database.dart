import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'app_database.g.dart';

/// {@template app_database}
/// The drift-managed database configuration
/// {@endtemplate}
@DriftDatabase()
class AppDatabase extends _$AppDatabase {
  /// {@macro app_database}
  AppDatabase(super.e);

  /// {@macro app_database}
  AppDatabase.defaults({required String name})
      : super(
          driftDatabase(
            name: name,
            native: const DriftNativeOptions(shareAcrossIsolates: true),
            // TODO(Sizzle): Update the sqlite3Wasm and driftWorker paths to match the location of the files in your project if needed.
            // https://drift.simonbinder.eu/web/#prerequisites
            web: DriftWebOptions(
              sqlite3Wasm: Uri.parse('sqlite3.wasm'),
              driftWorker: Uri.parse('drift_worker.js'),
            ),
          ),
        );

  @override
  int get schemaVersion => 1;
}
