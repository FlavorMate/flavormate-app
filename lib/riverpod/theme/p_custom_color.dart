import 'package:flavormate/riverpod/shared_preferences/p_shared_preferences.dart';
import 'package:flavormate/riverpod/theme/p_dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'p_custom_color.g.dart';

@riverpod
class PCustomColor extends _$PCustomColor {
  @override
  Future<DynamicColors?> build() async {
    final sp = ref.watch(pSharedPreferencesProvider).requireValue;

    final color = sp.getInt('theme_custom_color');

    if (color == null) return null;

    return DynamicColors(
      light: ColorScheme.fromSeed(
        seedColor: Color(color),
        brightness: Brightness.light,
      ),
      dark: ColorScheme.fromSeed(
        seedColor: Color(color),
        brightness: Brightness.dark,
      ),
    );
  }

  void setColor(Color? color) {
    final sp = ref.read(pSharedPreferencesProvider).requireValue;

    if (color == null) {
      sp.remove('theme_custom_color');
    } else {
      sp.setInt('theme_custom_color', color.value);
    }

    ref.invalidateSelf();
  }
}
