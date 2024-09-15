import 'package:flavormate/riverpod/root_bundle/p_backend_url.dart';
import 'package:flavormate/riverpod/shared_preferences/p_shared_preferences.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'p_server.g.dart';

@riverpod
class PServer extends _$PServer {
  @override
  String build() {
    final backendUrl = ref.read(pBackendUrlProvider).requireValue;
    if (backendUrl != null) {
      return backendUrl;
    }

    final provider = ref.watch(pSharedPreferencesProvider).requireValue;
    final server = provider.get('server') as String?;
    return server ?? '';
  }

  void set(String value) async {
    state = value;
    await ref
        .read(pSharedPreferencesProvider)
        .requireValue
        .setString('server', value);
  }
}
