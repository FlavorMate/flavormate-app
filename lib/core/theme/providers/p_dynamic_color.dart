import 'package:flavormate/core/theme/models/f_theme.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:system_theme/system_theme.dart';

part 'p_dynamic_color.g.dart';

@riverpod
class PDynamicColor extends _$PDynamicColor {
  @override
  FTheme? build() {
    if (!_supportAccentColor()) return null;

    return FTheme.fromColor(SystemTheme.accentColor.accent);
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
