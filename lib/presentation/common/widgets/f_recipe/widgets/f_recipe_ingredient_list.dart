import 'package:collection/collection.dart';
import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/data/models/local/common_recipe/common_ingredient.dart';
import 'package:flavormate/data/models/local/common_recipe/common_ingredient_group.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/presentation/common/widgets/f_table.dart';
import 'package:flavormate/presentation/common/widgets/f_text/f_text.dart';
import 'package:flutter/material.dart';

class FRecipeIngredientList extends StatelessWidget {
  final CommonIngredientGroup ingredientGroup;
  final double factor;

  List<CommonIngredient> get sortedIngredients =>
      ingredientGroup.ingredients.sorted((a, b) => a.index.compareTo(b.index));

  const FRecipeIngredientList({
    super.key,
    required this.ingredientGroup,
    required this.factor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: PADDING,
      children: [
        if (ingredientGroup.label != null)
          FText(
            ingredientGroup.label!,
            style: FTextStyle.titleLarge,
            weight: FontWeight.w500,
          ),

        FTable(
          header: [
            context.l10n.f_recipe_ingredient_list__amount,
            context.l10n.f_recipe_ingredient_list__ingredient,
          ],
          rows: [
            for (final ingredient in sortedIngredients)
              [ingredient.getAmountLabel(factor), ingredient.label],
          ],
          cellTextAlign: const [TextAlign.end, TextAlign.start],
          headerTextAlign: const [TextAlign.end, TextAlign.start],
          distributions: const [0.25, 0.75],
        ),
      ],
    );
  }
}
