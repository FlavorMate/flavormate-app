import 'package:flavormate/riverpod/theme/p_custom_color.dart';
import 'package:flavormate/riverpod/theme/p_dynamic_color.dart';
import 'package:flavormate/riverpod/theme/p_theme_mode.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'p_theme.g.dart';

@riverpod
class PTheme extends _$PTheme {
  @override
  Future<DynamicColors> build() async {
    final mode = ref.watch(pThemeModeProvider);

    final dynamic = await ref.watch(
      pDynamicColorProvider.selectAsync((data) => data),
    );

    final custom = await ref.watch(
      pCustomColorProvider.selectAsync((data) => data),
    );

    if (mode == CustomThemeMode.dynamic && dynamic != null) {
      return dynamic;
    } else if (mode == CustomThemeMode.custom && custom != null) {
      return custom;
    }

    return DynamicColors(
      light: ColorScheme.fromSeed(
        seedColor: Colors.lightGreen,
        brightness: Brightness.light,
      ),
      dark: ColorScheme.fromSeed(
        seedColor: Colors.lightGreen,
        brightness: Brightness.dark,
      ),
    );
  }
}

enum CustomThemeMode {
  flavormate,
  dynamic,
  custom;
}