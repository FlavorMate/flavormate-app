import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

extension ERef on Ref {
  void cacheFor(Duration duration) {
    // Immediately prevent the state from getting destroyed.
    final link = keepAlive();
    // After duration has elapsed, we re-enable automatic disposal.
    final cacheTimer = Timer(duration, link.close);
    // Optional: when the provider is recomputed (such as with ref.watch),
    // we cancel the pending timer.
    onDispose(cacheTimer.cancel);
  }
}
