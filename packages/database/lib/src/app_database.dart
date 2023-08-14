import 'package:drift/drift.dart';

part 'app_database.g.dart';

/// {@template app_database}
/// The drift-managed database configuration
/// {@endtemplate}
@DriftDatabase()
class AppDatabase extends _$AppDatabase {
  /// {@macro app_database}
  AppDatabase(super.openConnection);

  @override
  int get schemaVersion => 1;
}
