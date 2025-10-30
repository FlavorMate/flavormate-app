import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

abstract class URiverpod {
  static ProviderSubscription<AsyncValue<T?>> listenManual<T>(
    WidgetRef ref,
    ProviderListenable<AsyncValue<T?>> provider,
    Function(T data) onValue,
  ) {
    return ref.listenManual(provider, fireImmediately: true, (_, next) {
      if (!next.hasValue || next.value == null) return;
      onValue(next.value as T);
    });
  }
}
