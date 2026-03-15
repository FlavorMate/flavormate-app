import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/core/extensions/e_object.dart';
import 'package:flavormate/presentation/common/widgets/f_guide_card/f_guide_card.dart';
import 'package:flavormate/presentation/common/widgets/f_guide_card/f_guide_card_animation.dart';
import 'package:flavormate/presentation/common/widgets/f_text/f_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';

class FGuideCardComplete extends FGuideCard {
  final String? label;
  final double fontSize;

  const FGuideCardComplete({
    super.key,
    required super.id,
    required this.label,
    required this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    var text =
        label?.let(
          (it) => context.l10n.f_guide_card_complete__label_with_value(it),
        ) ??
        context.l10n.f_guide_card_complete__label_without_value;

    return builder(
      context,
      Column(
        mainAxisAlignment: .center,
        spacing: PADDING,
        children: [
          const FGuideCardAnimation(icon: MdiIcons.checkCircleOutline),
          FText(
            text,
            style: .titleMedium,
            textAlign: .center,
            fontSize: fontSize,
          ),
        ],
      ),
    );
  }
}
