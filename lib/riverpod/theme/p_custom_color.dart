import 'package:flavormate/models/t_theme.dart';
import 'package:flavormate/riverpod/shared_preferences/p_shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'p_custom_color.g.dart';

@riverpod
class PCustomColor extends _$PCustomColor {
  @override
  Future<TTheme?> build() async {
    final sp = ref.watch(pSharedPreferencesProvider).requireValue;

    final color = sp.getInt('theme_custom_color');

    if (color == null) return null;

    return TTheme.fromColor(Color(color));
  }

  void setColor(Color? color) {
    final sp = ref.read(pSharedPreferencesProvider).requireValue;

    if (color == null) {
      sp.remove('theme_custom_color');
    } else {
      sp.setInt('theme_custom_color', color.toARGB32());
    }

    ref.invalidateSelf();
  }
}
