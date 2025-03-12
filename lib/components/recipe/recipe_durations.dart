import 'package:flavormate/components/t_card.dart';
import 'package:flavormate/components/t_column.dart';
import 'package:flavormate/components/t_text.dart';
import 'package:flavormate/extensions/e_duration.dart';
import 'package:flavormate/l10n/generated/l10n.dart';
import 'package:flavormate/utils/constants.dart';
import 'package:flutter/material.dart';

class RecipeDurations extends StatelessWidget {
  final Duration? prepTime;
  final Duration? cookTime;
  final Duration? restTime;

  const RecipeDurations({
    super.key,
    required this.prepTime,
    required this.cookTime,
    required this.restTime,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      runSpacing: PADDING / 2,
      alignment: WrapAlignment.center,
      children: [
        RecipeDuration(
          duration: prepTime,
          label: L10n.of(context).c_recipe_duration_prep,
        ),
        RecipeDuration(
          duration: cookTime,
          label: L10n.of(context).c_recipe_duration_cook,
        ),
        RecipeDuration(
          duration: restTime,
          label: L10n.of(context).c_recipe_duration_rest,
        ),
      ],
    );
  }
}

class RecipeDuration extends StatelessWidget {
  final String label;
  final Duration? duration;

  const RecipeDuration({
    super.key,
    required this.duration,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: duration != null && duration != Duration.zero,
      child: TCard(
        child: TColumn(
          space: PADDING / 4,
          children: [
            TText(label, TextStyles.titleSmall),
            TText(duration!.beautify(context), TextStyles.headlineSmall),
          ],
        ),
      ),
    );
  }
}
