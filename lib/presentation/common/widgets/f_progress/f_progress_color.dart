import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';

class FProgressColor extends StatelessWidget {
  final double state;
  final bool optional;
  final Color color;
  final bool dynamicColors;

  const FProgressColor({
    super.key,
    required this.state,
    this.optional = false,
    this.color = Colors.white,
    this.dynamicColors = false,
  });

  @override
  Widget build(BuildContext context) {
    final double state = this.state.clamp(0.0, 1.0);
    Color color = dynamicColors
        ? _getProgressColor(state, context.colorScheme.brightness)
        : this.color;

    final child = switch (state) {
      0 =>
        optional
            ? Icon(MdiIcons.minusCircleOutline, color: color)
            : Icon(MdiIcons.alertCircleOutline, color: color),

      1 => Icon(MdiIcons.checkCircleOutline, color: color),
      _ => Stack(
        children: [
          CircularProgressIndicator(value: state, strokeWidth: 3, color: color),
          Center(
            child: Text(
              (state * 100).toInt().toString(),
              style: const TextStyle(fontSize: 12),
            ),
          ),
        ],
      ),
    };

    return SizedBox(height: 24, width: 24, child: child);
  }

  Color _getProgressColor(double value, Brightness brightness) {
    // Select color set based on brightness
    final colors = brightness == Brightness.light ? _lightColors : _darkColors;

    if (value <= 0.5) {
      return Color.lerp(colors['red']!, colors['yellow']!, value / 0.5)!;
    } else {
      return Color.lerp(
        colors['yellow']!,
        colors['green']!,
        (value - 0.5) / 0.5,
      )!;
    }
  }

  // Define colors for light mode
  static const _lightColors = {
    'red': Color(0xFFFF6B6B), // Soft red
    'yellow': Color(0xFFFFD93D), // Warm yellow
    'green': Color(0xFF6BCB77), // Fresh green
  };

  // Define colors for dark mode
  static const _darkColors = {
    'red': Color(0xFFFF4D4D), // Vibrant red
    'yellow': Color(0xFFFFCC00), // Rich yellow
    'green': Color(0xFF4CAF50), // Material green
  };
}
