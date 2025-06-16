import 'package:flavormate/riverpod/shared_preferences/p_shared_preferences.dart';
import 'package:flavormate/riverpod/theme/p_theme.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'p_theme_mode.g.dart';

@riverpod
class PThemeMode extends _$PThemeMode {
  @override
  CustomThemeMode build() {
    final sharedPreferences = ref
        .watch(pSharedPreferencesProvider)
        .requireValue;

    final modeString =
        sharedPreferences.getString('theme_mode') ?? 'flavormate';

    final mode = CustomThemeMode.values.byName(modeString);

    return mode;
  }

  void setMode(CustomThemeMode? single) {
    final sharedPreferences = ref
        .watch(pSharedPreferencesProvider)
        .requireValue;

    if (single == null) {
      sharedPreferences.remove('theme_mode');
    } else {
      sharedPreferences.setString('theme_mode', single.name);
    }

    ref.invalidateSelf();
  }
}
