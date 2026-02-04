import 'package:flavormate/core/theme/models/blended_colors.dart';
import 'package:flex_seed_scheme/flex_seed_scheme.dart';
import 'package:flutter/material.dart';

abstract class FTheme {
  static ColorScheme createColorScheme(
    Color color,
    Brightness brightness,
    FlexTones Function(Brightness) flextones,
  ) => SeedColorScheme.fromSeeds(
    primaryKey: color,
    respectMonochromeSeed: true,
    tones: flextones.call(brightness),
    brightness: brightness,
  );

  static ThemeData createTheme(
    Color color,
    Brightness brightness,
    FlexTones Function(Brightness) flextones,
  ) => ThemeData(
    actionIconTheme: ActionIconThemeData(
      backButtonIconBuilder: (context) => const Icon(Icons.arrow_back_rounded),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      scrolledUnderElevation: 0,
    ),
    brightness: brightness,
    colorScheme: createColorScheme(color, brightness, flextones),
    extensions: [BlendedColors.fromPrimary(color)],
    fontFamily: 'GoogleSansFlex',
  );
}
