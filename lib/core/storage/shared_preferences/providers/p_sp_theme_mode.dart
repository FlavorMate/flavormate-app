import 'package:flavormate/core/storage/shared_preferences/enums/sp_key.dart';
import 'package:flavormate/core/storage/shared_preferences/providers/p_sp.dart';
import 'package:flavormate/core/theme/enums/f_theme_mode.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'p_sp_theme_mode.g.dart';

final _key = SPKey.ThemeMode.name;

@riverpod
class PSPThemeMode extends _$PSPThemeMode {
  @override
  FThemeMode build() {
    final instance = ref.watch(pSPProvider).requireValue;

    final modeString = instance.getString(_key);

    if (modeString == null ||
        !FThemeMode.values.map((it) => it.name).contains(modeString)) {
      setMode(.custom);
      return .custom;
    }

    return FThemeMode.values.byName(modeString);
  }

  Future<void> setMode(FThemeMode themeMode) async {
    final instance = ref.watch(pSPProvider).requireValue;

    await instance.setString(_key, themeMode.name);

    ref.invalidateSelf();
  }
}
