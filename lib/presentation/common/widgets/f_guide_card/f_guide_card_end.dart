import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/presentation/common/widgets/f_guide_card/f_guide_card.dart';
import 'package:flavormate/presentation/common/widgets/f_guide_card/f_guide_card_animation.dart';
import 'package:flavormate/presentation/common/widgets/f_text/f_text.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:material_ui/material_ui.dart';

class FGuideCardEnd extends FGuideCard {
  final String label;
  final double fontSize;

  const FGuideCardEnd({
    super.key,
    required super.id,
    required this.label,
    required this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return builder(
      context,
      Column(
        mainAxisAlignment: .center,
        spacing: PADDING,
        children: [
          const FGuideCardAnimation(icon: Symbols.heart_check_rounded),
          FText(
            context.l10n.f_guide_card_end__label(label),
            style: .titleMedium,
            textAlign: .center,
            fontSize: fontSize,
            color: .onPrimaryContainer,
          ),
        ],
      ),
    );
  }
}
