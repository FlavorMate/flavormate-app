import 'package:flavormate/core/storage/root_bundle/backend_url/p_rb_backend_url.dart';
import 'package:flavormate/core/storage/shared_preferences/enums/sp_key.dart';
import 'package:flavormate/core/storage/shared_preferences/providers/p_sp.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'p_sp_current_server.g.dart';

final _key = SPKey.CurrentServer.name;

@Riverpod(keepAlive: true)
class PSPCurrentServer extends _$PSPCurrentServer {
  @override
  String? build() {
    final backendUrl = ref.watch(pRBBackendUrlProvider).value;
    if (backendUrl != null) {
      return backendUrl;
    }

    final instance = ref.watch(pSPProvider).requireValue;
    return instance.getString(_key);
  }

  Future<void> set(String? value) async {
    final instance = ref.read(pSPProvider).requireValue;
    if (value == null) {
      await instance.remove(_key);
    } else {
      await instance.setString(_key, value);
    }
    state = value;
  }
}
