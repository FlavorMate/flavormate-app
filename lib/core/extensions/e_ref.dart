import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';

extension ERef on WidgetRef {
  ProviderSubscription<StateT> listenOnce<StateT>(
    ProviderListenable<StateT> provider,
    void Function(StateT) listener,
  ) {
    bool ready = false;
    return listenManual(provider, fireImmediately: true, (_, data) {
      if (ready) return;
      if (data == null) return;

      listener.call(data);

      ready = true;
    });
  }
}
