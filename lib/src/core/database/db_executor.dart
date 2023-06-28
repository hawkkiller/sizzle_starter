export 'package:sizzle_starter/src/core/database/src/db_executor_stub.dart'
    if (dart.library.ffi) 'src/db_executor_native.dart'
    if (dart.library.html) 'src/db_executor_web.dart';
