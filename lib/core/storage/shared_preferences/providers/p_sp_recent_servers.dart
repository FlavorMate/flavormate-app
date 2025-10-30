import 'package:flavormate/core/storage/shared_preferences/enums/sp_key.dart';
import 'package:flavormate/core/storage/shared_preferences/providers/p_sp.dart';
import 'package:flavormate/core/storage/shared_preferences/providers/p_sp_current_server.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'p_sp_recent_servers.g.dart';

final _key = SPKey.RecentServers.name;

@Riverpod(keepAlive: true)
class PSPRecentServers extends _$PSPRecentServers {
  @override
  List<String> build() {
    final instance = ref.watch(pSPProvider).requireValue;
    return instance.getStringList(_key) ?? [];
  }

  Future<void> addServer() async {
    final instance = ref.read(pSPProvider).requireValue;

    final value = ref.read(pSPCurrentServerProvider);

    if (value == null || state.contains(value)) return;

    state.add(value);

    await instance.setStringList(_key, state);
  }
}
