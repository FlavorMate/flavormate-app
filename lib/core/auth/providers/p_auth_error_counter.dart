import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'p_auth_error_counter.g.dart';

@Riverpod(keepAlive: true)
class PAuthErrorCounter extends _$PAuthErrorCounter {
  Timer? _resetTimer;

  // Configure your inactivity window here (or make it configurable via parameters).
  static const Duration _inactivityWindow = Duration(seconds: 10);

  @override
  int build() {
    ref.onDispose(() {
      _resetTimer?.cancel();
      _resetTimer = null;
    });

    return 0;
  }

  void increase() {
    state++;

    _resetTimer?.cancel();
    _resetTimer = Timer(_inactivityWindow, () {
      // Extra safety: avoid setting state if this notifier got disposed.
      if (!ref.mounted) return;
      state = 0;
    });
  }

  void resetNow() {
    _resetTimer?.cancel();
    _resetTimer = null;
    state = 0;
  }
}
