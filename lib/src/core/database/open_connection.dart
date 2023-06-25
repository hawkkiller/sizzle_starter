export 'package:sizzle_starter/src/core/database/src/open_connection_stub.dart'
    if (dart.library.io) 'src/open_connection_io.dart'
    if (dart.library.html) 'src/open_connection_html.dart';
