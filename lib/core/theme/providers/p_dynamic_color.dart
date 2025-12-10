import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:system_theme/system_theme.dart';

part 'p_dynamic_color.g.dart';

@riverpod
class PDynamicColor extends _$PDynamicColor {
  @override
  Color? build() {
    if (!_supportAccentColor()) return null;

    return SystemTheme.accentColor.accent.withAlpha(255);
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
