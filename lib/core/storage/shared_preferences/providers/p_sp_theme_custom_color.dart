import 'package:flavormate/core/storage/shared_preferences/enums/sp_key.dart';
import 'package:flavormate/core/storage/shared_preferences/providers/p_sp.dart';
import 'package:flavormate/core/theme/models/f_theme.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'p_sp_theme_custom_color.g.dart';

final _key = SPKey.ThemeCustomColor.name;

@riverpod
class PSPThemeCustomColor extends _$PSPThemeCustomColor {
  @override
  FTheme? build() {
    final instance = ref.watch(pSPProvider).requireValue;

    final color = instance.getInt(_key);

    if (color == null) return null;

    return FTheme.fromColor(Color(color));
  }

  Future<void> setColor(Color? color) async {
    final instance = ref.read(pSPProvider).requireValue;

    if (color == null) {
      await instance.remove(_key);
    } else {
      await instance.setInt(_key, color.toARGB32());
    }

    ref.invalidateSelf();
  }
}
