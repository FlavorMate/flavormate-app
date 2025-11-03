import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flutter/material.dart';

part 'f_text_color.dart';
part 'f_text_style.dart';

class FText extends StatelessWidget {
  final String label;
  final FTextStyle style;
  final double textHeight;
  final FTextColor? color;
  final TextAlign? textAlign;
  final TextOverflow? textOverflow;
  final int? maxLines;

  const FText(
    this.label, {
    required this.style,
    this.textHeight = 1,
    this.textAlign,
    this.color,
    this.textOverflow,
    this.maxLines,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final s = style.geFTextStyle(context);
    final c = color?.getThemeColor(context);
    return Text(
      label,
      textAlign: textAlign,
      style: s?.copyWith(color: c, height: textHeight),
      overflow: textOverflow,
      maxLines: maxLines,
    );
  }
}
