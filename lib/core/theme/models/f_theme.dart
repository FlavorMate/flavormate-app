import 'package:flavormate/core/theme/models/blended_colors.dart';
import 'package:flutter/material.dart';

class FTheme {
  final ColorScheme? light;
  final ColorScheme? dark;

  final BlendedColors lightBlendedColors;
  final BlendedColors darkBlendedColors;

  FTheme({
    required this.light,
    required this.dark,
    required this.lightBlendedColors,
    required this.darkBlendedColors,
  });

  factory FTheme.fromColor(Color color) {
    final lightColorScheme = ColorScheme.fromSeed(
      seedColor: color,
      brightness: Brightness.light,
    );

    final lightBlendedColors = BlendedColors.fromPrimary(
      lightColorScheme.primary,
    );

    final darkColorScheme = ColorScheme.fromSeed(
      seedColor: color,
      brightness: Brightness.dark,
    );

    final darkBlendedColors = BlendedColors.fromPrimary(
      darkColorScheme.primary,
    );

    return FTheme(
      light: lightColorScheme,
      lightBlendedColors: lightBlendedColors,
      dark: darkColorScheme,
      darkBlendedColors: darkBlendedColors,
    );
  }
}
