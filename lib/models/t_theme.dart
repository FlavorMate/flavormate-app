import 'package:flutter/material.dart';

class TTheme {
  final ColorScheme? light;
  final ColorScheme? dark;

  TTheme({required this.light, required this.dark});

  factory TTheme.fromColor(Color color) {
    return TTheme(
      light: ColorScheme.fromSeed(
        seedColor: color,
        brightness: Brightness.light,
      ),
      dark: ColorScheme.fromSeed(seedColor: color, brightness: Brightness.dark),
    );
  }
}
