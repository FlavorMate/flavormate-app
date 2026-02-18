import 'dart:async';

class UDebouncer {
  final Duration _duration;
  Timer? _timer;

  UDebouncerState state = UDebouncerState.idle;

  UDebouncer({Duration duration = const Duration(seconds: 1)})
    : _duration = duration;

  void run(void Function() action) {
    state = UDebouncerState.pending;
    _timer?.cancel();
    _timer = Timer(_duration, () {
      state = UDebouncerState.saving;
      action.call();
      state = UDebouncerState.idle;
    });
  }

  void dispose() {
    _timer?.cancel();
    _timer = null;
  }
}

enum UDebouncerState { idle, pending, saving }
