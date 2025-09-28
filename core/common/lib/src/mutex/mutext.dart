import 'dart:async';
import 'dart:collection';

/// A simple mutex implementation using a queue of completers.
/// This allows for synchronizing access to a critical section of code,
/// ensuring that only one task can execute the critical section at a time.
class Mutext {
  Mutext();

  final _queue = DoubleLinkedQueue<Completer<void>>();

  /// Locks the mutex and returns
  /// a future that completes when the lock is acquired.
  Future<void> lock() {
    final previous = _queue.lastOrNull?.future ?? Future<void>.value();
    _queue.add(Completer<void>.sync());

    return previous;
  }

  /// Unlocks the mutex, allowing the next waiting task to proceed.
  void unlock() {
    if (_queue.isEmpty) {
      assert(false, 'Mutex unlock called when no tasks are waiting.');
      return;
    }

    final completer = _queue.removeFirst();

    if (completer.isCompleted) {
      assert(false, 'Mutex unlock called when the completer is already completed.');
      return;
    }

    completer.complete();
  }

  /// Synchronizes the execution of a function, ensuring that only one
  /// task can execute the function at a time.
  Future<T> runLocked<T>(FutureOr<T> Function() fn) async {
    await lock();

    try {
      return await fn();
    } finally {
      unlock();
    }
  }
}
