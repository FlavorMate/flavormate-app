import 'package:flutter/material.dart';

@immutable
class BlendedColors extends ThemeExtension<BlendedColors> {
  final Color success;
  final Color error;
  final Color warning;
  final Color info;

  const BlendedColors({
    required this.success,
    required this.error,
    required this.warning,
    required this.info,
  });

  factory BlendedColors.fromPrimary(Color primary) {
    return BlendedColors(
      success: Color.lerp(primary, Colors.green, 0.4)!,
      error: Color.lerp(primary, Colors.red, 0.7)!,
      warning: Color.lerp(primary, Colors.orange, 0.5)!,
      info: Color.lerp(primary, Colors.blue, 0.3)!,
    );
  }

  @override
  BlendedColors copyWith({
    Color? success,
    Color? error,
    Color? warning,
    Color? info,
  }) {
    return BlendedColors(
      success: success ?? this.success,
      error: error ?? this.error,
      warning: warning ?? this.warning,
      info: info ?? this.info,
    );
  }

  @override
  BlendedColors lerp(ThemeExtension<BlendedColors>? other, double t) {
    if (other is! BlendedColors) return this;
    return BlendedColors(
      success: Color.lerp(success, other.success, t)!,
      error: Color.lerp(error, other.error, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      info: Color.lerp(info, other.info, t)!,
    );
  }
}
