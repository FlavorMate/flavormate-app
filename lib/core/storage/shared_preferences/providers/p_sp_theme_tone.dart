import 'package:flavormate/core/extensions/e_shared_preferences.dart';
import 'package:flavormate/core/storage/shared_preferences/enums/sp_key.dart';
import 'package:flavormate/core/storage/shared_preferences/providers/p_sp.dart';
import 'package:flavormate/core/theme/enums/f_theme_tone.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'p_sp_theme_tone.g.dart';

final _key = SPKey.ThemeTone.name;

@riverpod
class PSPThemeTone extends _$PSPThemeTone {
  @override
  FThemeTone build() {
    final instance = ref.watch(pSPProvider).requireValue;

    final tone = instance.getEnum(_key, FThemeTone.values);

    if (tone == null) {
      setMode(.Material);
      return .Material;
    }

    return tone;
  }

  Future<void> setMode(FThemeTone themeTone) async {
    final instance = ref.watch(pSPProvider).requireValue;

    await instance.setEnum(_key, themeTone);

    ref.invalidateSelf();
  }
}
