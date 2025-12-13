import 'package:flavormate/core/storage/shared_preferences/enums/sp_key.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'p_sp.g.dart';

@Riverpod(keepAlive: true)
class PSP extends _$PSP {
  @override
  Future<SharedPreferences> build() {
    return SharedPreferences.getInstance();
  }

  // Clear anything but recent servers
  Future<void> clear() async {
    final recentServers =
        state.requireValue.getStringList(
          SPKey.RecentServers.name,
        ) ??
        [];

    await state.requireValue.clear();

    await state.requireValue.setStringList(
      SPKey.RecentServers.name,
      recentServers,
    );

    ref.invalidateSelf();
  }
}
