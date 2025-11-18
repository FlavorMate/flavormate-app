import 'package:flavormate/core/storage/shared_preferences/enums/sp_key.dart';
import 'package:flavormate/core/storage/shared_preferences/providers/p_sp.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'p_settings_full_image.g.dart';

@riverpod
class PSettingsFullImage extends _$PSettingsFullImage {
  @override
  bool build() {
    final sp = ref.watch(pSPProvider).requireValue;

    return sp.getBool(SPKey.SettingsFullImage.name) ?? false;
  }

  void set(bool value) {
    final sp = ref.read(pSPProvider).requireValue;
    sp.setBool(SPKey.SettingsFullImage.name, value);
  }
}
