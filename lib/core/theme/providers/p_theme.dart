import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/core/storage/shared_preferences/providers/p_sp_theme_custom_color.dart';
import 'package:flavormate/core/storage/shared_preferences/providers/p_sp_theme_mode.dart';
import 'package:flavormate/core/theme/enums/f_theme_mode.dart';
import 'package:flavormate/core/theme/models/f_theme.dart';
import 'package:flavormate/core/theme/providers/p_dynamic_color.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'p_theme.g.dart';

@riverpod
class PTheme extends _$PTheme {
  @override
  Future<FTheme> build() async {
    final mode = ref.watch(pSPThemeModeProvider);
    final dynamic = ref.watch(pDynamicColorProvider);
    final custom = ref.watch(pSPThemeCustomColorProvider);

    if (mode == null) {
      if (dynamic != null) {
        await ref
            .read(pSPThemeModeProvider.notifier)
            .setMode(FThemeMode.dynamic);
      } else {
        await ref
            .read(pSPThemeModeProvider.notifier)
            .setMode(FThemeMode.flavormate);
      }
    }

    if (mode == FThemeMode.dynamic && dynamic != null) {
      return dynamic;
    } else if (mode == FThemeMode.custom && custom != null) {
      return custom;
    }

    return FTheme.fromColor(FLAVORMATE_COLOR);
  }
}
