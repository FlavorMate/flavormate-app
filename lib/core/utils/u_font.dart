import 'package:flutter/material.dart';

abstract class UFont {
  static double calcHeight(
    BuildContext context,
    String? label,
    TextStyle style, {
    double maxWidth = double.infinity,
    int? maxLines,
  }) {
    final tp = TextPainter(
      text: TextSpan(text: label, style: style),
      textScaler: MediaQuery.textScalerOf(context),
      textDirection: Directionality.of(context),
      maxLines: maxLines,
    )..layout(maxWidth: maxWidth);

    return tp.height;
  }
}
