import 'package:flavormate/core/extensions/e_shared_preferences.dart';
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

    final mode = instance.getEnum(_key, FThemeMode.values);

    if (mode == null) {
      setMode(.custom);
      return .custom;
    }

    return mode;
  }

  Future<void> setMode(FThemeMode themeMode) async {
    final instance = ref.watch(pSPProvider).requireValue;

    await instance.setEnum(_key, themeMode);

    ref.invalidateSelf();
  }
}
