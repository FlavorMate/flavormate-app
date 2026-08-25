import 'package:dynamic_color/dynamic_color.dart';
import 'package:flavormate/core/extensions/e_object.dart';
import 'package:flavormate/core/theme/utils/u_theme.dart';
import 'package:material_ui/material_ui.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'p_dynamic_color.g.dart';

@riverpod
class PDynamicColor extends _$PDynamicColor {
  @override
  Future<Color?> build() async {
    if (!UTheme.supportAccentColor()) return null;

    final colorDesktop = await DynamicColorPlugin.getAccentColor();
    final schemeAndroid = await DynamicColorPlugin.getCorePalette();
    final colorAndroid = schemeAndroid?.let(
      (it) => Color(it.primary.keyColor.toInt()),
    );

    ref.keepAlive();

    return colorDesktop ?? colorAndroid;
  }
}
