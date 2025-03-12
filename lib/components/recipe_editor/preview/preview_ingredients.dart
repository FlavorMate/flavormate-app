import 'package:flavormate/components/t_column.dart';
import 'package:flavormate/components/t_table.dart';
import 'package:flavormate/components/t_text.dart';
import 'package:flavormate/extensions/e_number.dart';
import 'package:flavormate/l10n/generated/l10n.dart';
import 'package:flavormate/models/recipe_draft/ingredients/ingredient_group_draft.dart';
import 'package:flavormate/models/recipe_draft/serving_draft/serving_draft.dart';
import 'package:flavormate/utils/constants.dart';
import 'package:flutter/material.dart';

class PreviewIngredients extends StatelessWidget {
  final List<IngredientGroupDraft> ingredientGroups;

  final ServingDraft serving;

  const PreviewIngredients({
    super.key,
    required this.ingredientGroups,
    required this.serving,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TText(L10n.of(context).c_recipe_ingredients, TextStyles.headlineMedium),
        const SizedBox(height: PADDING),
        Text('${serving.amount.beautify} ${serving.label}'),
        const SizedBox(height: PADDING),
        for (final ingredientGroup in ingredientGroups)
          TColumn(
            children: [
              if (ingredientGroup.label != null)
                TText(ingredientGroup.label!, TextStyles.titleLarge),
              TTable(
                header: [
                  L10n.of(context).c_recipe_ingredients_amount,
                  L10n.of(context).c_recipe_ingredients_ingredient,
                ],
                rows: [
                  for (final ingredient in ingredientGroup.ingredients)
                    [
                      [
                        ingredient.amount?.beautify ?? '',
                        ingredient.unit?.beautify,
                      ].nonNulls.join(' '),
                      // '${(ingredient.amount) <= 0 ? '' : (ingredient.amount / serving.amount).beautify} ${ingredient.unit?.beautify}',
                      ingredient.label,
                    ],
                ],
                cellTextAlign: const [TextAlign.end, TextAlign.start],
                headerTextAlign: const [TextAlign.end, TextAlign.start],
                distributions: const [0.25, 0.75],
              ),
            ],
          ),
      ],
    );
  }
}
