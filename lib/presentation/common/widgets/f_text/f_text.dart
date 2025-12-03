import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/core/extensions/e_object.dart';
import 'package:flutter/material.dart';

part 'f_text_color.dart';
part 'f_text_font_family.dart';
part 'f_text_style.dart';

class FText extends StatelessWidget {
  final String label;
  final FTextStyle style;
  final double? textHeight;
  final FTextColor? color;
  final TextAlign? textAlign;
  final TextOverflow? textOverflow;
  final FontWeight? weight;
  final FTextFontFamily? fontFamily;
  final int? maxLines;

  const FText(
    this.label, {
    required this.style,
    this.textHeight,
    this.textAlign,
    this.color,
    this.textOverflow,
    this.weight,
    this.fontFamily,
    this.maxLines,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final s = style.geFTextStyle(context);
    final c = color?.getThemeColor(context);
    final variation = weight?.let(
      (it) => [
        FontVariation.weight(it.value.toDouble()),
      ],
    );
    return Text(
      label,
      textAlign: textAlign,
      style: s?.copyWith(
        color: c,
        height: textHeight,
        fontFamily: fontFamily?.geFTextFontFamily(),
        fontWeight: weight,
        fontVariations: variation,
      ),
      overflow: textOverflow,
      maxLines: maxLines,
    );
  }
}
