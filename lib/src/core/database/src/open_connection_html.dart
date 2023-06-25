import 'package:database/database.dart';
import 'package:drift/web.dart';

AppDatabase openConnection(String name) {
  final db = WebDatabase(name);

  return AppDatabase(db);
}
