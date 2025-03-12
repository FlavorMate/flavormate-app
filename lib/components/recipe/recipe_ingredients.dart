import 'package:flavormate/components/t_column.dart';
import 'package:flavormate/components/t_icon_button.dart';
import 'package:flavormate/components/t_row.dart';
import 'package:flavormate/components/t_table.dart';
import 'package:flavormate/components/t_text.dart';
import 'package:flavormate/extensions/e_number.dart';
import 'package:flavormate/l10n/generated/l10n.dart';
import 'package:flavormate/models/recipe/ingredients/ingredient.dart';
import 'package:flavormate/models/recipe/ingredients/ingredient_group.dart';
import 'package:flavormate/models/recipe/serving/serving.dart';
import 'package:flavormate/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';

class RecipeIngredients extends StatelessWidget {
  final List<IngredientGroup> ingredientGroups;

  final void Function() decreaseServing;
  final void Function() increaseServing;

  final double factor;
  final Serving serving;

  const RecipeIngredients({
    super.key,
    required this.ingredientGroups,
    required this.decreaseServing,
    required this.increaseServing,
    required this.factor,
    required this.serving,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TText(L10n.of(context).c_recipe_ingredients, TextStyles.headlineMedium),
        const SizedBox(height: PADDING),
        TRow(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TIconButton(onPressed: decreaseServing, icon: MdiIcons.minus),
            Text('${factor.beautify} ${serving.label}'),
            TIconButton(onPressed: increaseServing, icon: MdiIcons.plus),
          ],
        ),
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
                        _getAmount(ingredient),
                        ingredient.unitLabel(factor / serving.amount),
                      ].nonNulls.join(' '),
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

  String? _getAmount(Ingredient ingredient) {
    if (ingredient.amount == null) return null;

    if ((ingredient.amount! * factor) > 0) {
      return (ingredient.amount! * factor / serving.amount).beautify;
    }

    return null;
  }
}
