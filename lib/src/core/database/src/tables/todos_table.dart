// ignore_for_file: prefer-declaring-const-constructor
import 'package:drift/drift.dart';

/// Todos table definition
class TodosTable extends Table {
  /// The identifier for this todo.
  IntColumn get id => integer().autoIncrement()();

  /// The title of this todo.
  TextColumn get title => text().withLength(min: 6, max: 32)();

  /// The content of this todo.
  TextColumn get content => text().named('body')();

  /// Category of this todo.
  IntColumn get category => integer().nullable()();
}
