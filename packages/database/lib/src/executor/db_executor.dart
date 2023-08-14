export 'package:database/src/executor/db_executor_stub.dart'
    if (dart.library.ffi) 'package:database/src/executor/db_executor_native.dart'
    if (dart.library.html) 'package:database/src/executor/db_executor_web.dart';
