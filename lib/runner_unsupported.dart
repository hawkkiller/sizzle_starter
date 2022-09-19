// Unsupported runner
Future<void> run() => _throw();

Never _throw() => throw UnsupportedError('Cannot run on this platform');
