import 'package:drift/drift.dart';
import 'package:sizzle_starter/src/core/components/database/database.dart';
import 'package:sizzle_starter/src/core/components/database/src/tables/todos_table.dart';

part 'app_database.g.dart';

/// {@template app_database}
/// The drift-managed database configuration
/// {@endtemplate}
@DriftDatabase(tables: [TodosTable])
class AppDatabase extends _$AppDatabase {
  /// {@macro app_database}
  AppDatabase([QueryExecutor? executor]) : super(executor ?? createExecutor());

  @override
  int get schemaVersion => 1;
}
