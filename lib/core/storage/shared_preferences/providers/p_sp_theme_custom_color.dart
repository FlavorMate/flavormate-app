import 'package:flavormate/core/constants/color_constants.dart';
import 'package:flavormate/core/storage/shared_preferences/enums/sp_key.dart';
import 'package:flavormate/core/storage/shared_preferences/providers/p_sp.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'p_sp_theme_custom_color.g.dart';

final _key = SPKey.ThemeCustomColor.name;

@riverpod
class PSPThemeCustomColor extends _$PSPThemeCustomColor {
  @override
  Color build() {
    final instance = ref.watch(pSPProvider).requireValue;

    final color = instance.getInt(_key);

    if (color == null) {
      setColor(MiscColor.flavormate.color);
      return MiscColor.flavormate.color;
    }

    return Color(color);
  }

  Future<void> setColor(Color color) async {
    final instance = ref.read(pSPProvider).requireValue;

    await instance.setInt(_key, color.toARGB32());

    ref.invalidateSelf();
  }
}
