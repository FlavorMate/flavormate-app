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

  Future<void> clear() async {
    for (final key in SPKey.values) {
      if (key == SPKey.RecentServers) continue;

      await state.requireValue.remove(key.name);
    }

    ref.invalidateSelf();
  }
}
