import 'package:flavormate/core/extensions/e_shared_preferences.dart';
import 'package:flavormate/core/storage/shared_preferences/enums/sp_key.dart';
import 'package:flavormate/core/storage/shared_preferences/enums/sp_settings_image_mode.dart';
import 'package:flavormate/core/storage/shared_preferences/providers/p_sp.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'p_settings_full_image.g.dart';

@riverpod
class PSettingsFullImage extends _$PSettingsFullImage {
  String get _key => SPKey.SettingsFullImage.name;

  @override
  SpSettingsImageMode build() {
    final sp = ref.watch(pSPProvider).requireValue;

    return sp.getEnum(_key, SpSettingsImageMode.values) ??
        SpSettingsImageMode.FitMode;
  }

  void set(SpSettingsImageMode value) {
    final sp = ref.read(pSPProvider).requireValue;

    sp.setEnum(_key, value);

    ref.invalidateSelf();
  }
}
