import 'package:flavormate/models/t_theme.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:system_theme/system_theme.dart';

part 'p_dynamic_color.g.dart';

@riverpod
class PDynamicColor extends _$PDynamicColor {
  @override
  Future<TTheme?> build() async {
    if (!_supportAccentColor()) return null;

    return TTheme.fromColor(SystemTheme.accentColor.accent);
  }

  bool _supportAccentColor() {
    return !kIsWeb &&
        [
          TargetPlatform.windows,
          TargetPlatform.macOS,
          TargetPlatform.android,
          TargetPlatform.linux,
        ].contains(defaultTargetPlatform);
  }
}
