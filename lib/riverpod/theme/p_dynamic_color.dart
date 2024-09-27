import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'p_dynamic_color.g.dart';

@riverpod
class PDynamicColor extends _$PDynamicColor {
  @override
  Future<DynamicColors?> build() async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      final corePalette = await DynamicColorPlugin.getCorePalette();

      if (corePalette != null) {
        debugPrint('dynamic_color: Core palette detected.');
        return DynamicColors(
          light: corePalette.toColorScheme(
            brightness: Brightness.light,
          ),
          dark: corePalette.toColorScheme(
            brightness: Brightness.dark,
          ),
        );
      }
    } on PlatformException {
      debugPrint('dynamic_color: Failed to obtain core palette.');
    }

    try {
      final Color? accentColor = await DynamicColorPlugin.getAccentColor();

      if (accentColor != null) {
        debugPrint('dynamic_color: Accent color detected.');

        return DynamicColors(
          light: ColorScheme.fromSeed(
            seedColor: accentColor,
            brightness: Brightness.light,
          ),
          dark: ColorScheme.fromSeed(
            seedColor: accentColor,
            brightness: Brightness.dark,
          ),
        );
      }
    } on PlatformException {
      debugPrint('dynamic_color: Failed to obtain accent color.');
    }

    debugPrint('dynamic_color: Dynamic color not detected on this device.');
    return null;
  }
}

class DynamicColors {
  final ColorScheme? light;
  final ColorScheme? dark;

  DynamicColors({required this.light, required this.dark});
}
