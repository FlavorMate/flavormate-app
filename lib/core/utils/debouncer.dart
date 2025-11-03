import 'dart:async';

class Debouncer {
  final Duration _duration;
  Timer? _timer;

  DebouncerState state = DebouncerState.Idle;

  Debouncer({Duration duration = const Duration(seconds: 1)})
    : _duration = duration;

  void run(void Function() action) {
    state = DebouncerState.Pending;
    _timer?.cancel();
    _timer = Timer(_duration, () {
      state = DebouncerState.Saving;
      action.call();
      state = DebouncerState.Idle;
    });
  }

  void dispose() {
    _timer?.cancel();
    _timer = null;
  }
}

enum DebouncerState { Idle, Pending, Saving }
