import 'package:flavormate/core/storage/shared_preferences/providers/p_sp_theme_custom_color.dart';
import 'package:flavormate/core/storage/shared_preferences/providers/p_sp_theme_mode.dart';
import 'package:flavormate/core/theme/providers/p_dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'p_theme.g.dart';

@riverpod
class PTheme extends _$PTheme {
  @override
  Future<Color> build() async {
    final mode = ref.watch(pSPThemeModeProvider);
    final dynamic = ref.watch(pDynamicColorProvider);
    final custom = ref.watch(pSPThemeCustomColorProvider);

    if (mode == .dynamic && dynamic != null) {
      return dynamic;
    } else {
      return custom;
    }
  }
}
