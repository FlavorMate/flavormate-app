import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'p_timer.g.dart';

@riverpod
class PTimer extends _$PTimer {
  @override
  Timer? build(String id) {
    return null;
  }

  void start(Future<void> Function() callback) {
    state?.cancel();
    state = Timer(const Duration(seconds: 1), () async {
      await callback();
      state = null;
      ref.notifyListeners();
    });
  }

  Future<void> run(Future<void> Function() callback) async {
    state?.cancel();
    await callback();
    state = null;
    ref.notifyListeners();
  }

  void cancel() {
    state?.cancel();
  }
}
