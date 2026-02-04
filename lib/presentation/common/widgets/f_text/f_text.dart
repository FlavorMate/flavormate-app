import 'dart:ui';

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
  final FontWeight? fontWeight;
  final FTextFontFamily? fontFamily;
  final int? maxLines;

  final double? fontWidth;
  final double fontRoundness;

  const FText(
    this.label, {
    required this.style,
    this.textHeight,
    this.textAlign,
    this.color,
    this.textOverflow,
    this.fontWeight,
    this.fontFamily,
    this.maxLines,
    this.fontWidth,
    this.fontRoundness = 0,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final s = style.geFTextStyle(context);
    final c = color?.getThemeColor(context);
    return Text(
      label,
      textAlign: textAlign,
      style: s?.copyWith(
        color: c,
        height: textHeight,
        fontFamily: fontFamily?.geFTextFontFamily(),
        fontWeight: fontWeight,
        fontVariations: [
          ?fontWeight?.let((it) => FontVariation.weight(it.value.toDouble())),
          ?fontWidth?.let(FontVariation.width),
          FontVariation('ROND', clampDouble(fontRoundness, 0, 100)),
        ],
      ),
      overflow: textOverflow,
      maxLines: maxLines,
    );
  }
}
