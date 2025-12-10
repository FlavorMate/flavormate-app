import 'package:flavormate/core/theme/models/blended_colors.dart';
import 'package:flex_seed_scheme/flex_seed_scheme.dart';
import 'package:flutter/material.dart';

abstract class FTheme {
  static ColorScheme createColorScheme(Color color, Brightness brightness) =>
      SeedColorScheme.fromSeeds(
        primaryKey: color,
        respectMonochromeSeed: true,
        tones: .material(brightness),
        brightness: brightness,
      );

  static ThemeData createTheme(Color color, Brightness brightness) => ThemeData(
    brightness: brightness,
    colorScheme: createColorScheme(color, brightness),
    extensions: [BlendedColors.fromPrimary(color)],
    fontFamily: 'GoogleSansFlex',
  );
}
