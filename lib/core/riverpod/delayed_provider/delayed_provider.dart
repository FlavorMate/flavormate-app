import 'package:flutter_riverpod/flutter_riverpod.dart';

mixin DebounceProvider {
  Future<void> debounce(
    Ref ref, {
    Duration duration = const Duration(seconds: 1),
  }) async {
    // We capture whether the provider is currently disposed or not.
    var didDispose = false;
    ref.onDispose(() => didDispose = true);

    // We delay the request by 1000ms, to wait for the user to stop refreshing.
    await Future<void>.delayed(duration);

    // If the provider was disposed during the delay, it means that the user
    // refreshed again. We throw an exception to cancel the request.
    // It is safe to use an exception here, as it will be caught by Riverpod.
    if (didDispose) {
      throw Exception('Cancelled');
    }
  }
}
