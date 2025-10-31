import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/data/models/local/common_recipe/common_nutrition.dart';
import 'package:flavormate/data/models/local/common_recipe/common_recipe.dart';
import 'package:flavormate/generated/l10n/l10n.dart';
import 'package:flavormate/presentation/common/widgets/f_icon_button.dart';
import 'package:flavormate/presentation/common/widgets/f_recipe/layouts/f_recipe_nutrition_mobile_layout.dart';
import 'package:flavormate/presentation/common/widgets/f_recipe/widgets/f_recipe_bring_button.dart';
import 'package:flavormate/presentation/common/widgets/f_recipe/widgets/f_recipe_description.dart';
import 'package:flavormate/presentation/common/widgets/f_recipe/widgets/f_recipe_durations.dart';
import 'package:flavormate/presentation/common/widgets/f_recipe/widgets/f_recipe_ingredient_group_list.dart';
import 'package:flavormate/presentation/common/widgets/f_recipe/widgets/f_recipe_instruction_group_list.dart';
import 'package:flavormate/presentation/common/widgets/f_recipe/widgets/f_recipe_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';

class FRecipeMobileLayout extends StatelessWidget {
  final CommonRecipe recipe;
  final CommonNutrition? nutrition;

  final double amountFactor;
  final double newAmount;

  final VoidCallback decreaseServing;
  final VoidCallback increaseServing;

  final bool enableBring;
  final bool enableBookmark;

  final VoidCallback? addToBring;
  final VoidCallback? addBookmark;

  const FRecipeMobileLayout({
    super.key,
    required this.recipe,
    this.nutrition,
    required this.amountFactor,
    required this.newAmount,
    required this.decreaseServing,
    required this.increaseServing,
    required this.enableBring,
    required this.enableBookmark,
    this.addToBring,
    this.addBookmark,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Column(
          spacing: PADDING,
          children: [
            FRecipeTitle(title: recipe.label),

            if (recipe.description != null)
              FRecipeDescription(description: recipe.description!),

            if (enableBring || enableBookmark) const Divider(),
            if (enableBring)
              FRecipeBringButton(width: BUTTON_WIDTH, onPressed: addToBring!),
            if (enableBookmark)
              FIconButton(
                width: BUTTON_WIDTH,
                onPressed: addBookmark!,
                icon: MdiIcons.bookmark,
                label: L10n.of(context).f_recipe_layout__save_recipe,
              ),

            const Divider(),
            FRecipeDurations(
              prepTime: recipe.prepTime,
              cookTime: recipe.cookTime,
              restTime: recipe.restTime,
            ),

            if (nutrition != null)
              Column(
                spacing: PADDING,
                children: [
                  const Divider(),
                  FRecipeNutritionMobileLayout(
                    nutrition: nutrition,
                    amountFactor: amountFactor,
                    servingLabel: recipe.serving.label,
                  ),
                ],
              ),

            const Divider(),
            FRecipeIngredientGroupList(
              ingredientGroups: recipe.ingredientGroups,
              decreaseServing: decreaseServing,
              increaseServing: increaseServing,
              amountFactor: amountFactor,
              newAmount: newAmount,
              servingLabel: recipe.serving.label,
            ),

            const Divider(),
            FRecipeInstructionGroupList(
              instructionGroups: recipe.instructionGroups,
              amountFactor: amountFactor,
            ),
          ],
        ),
      ],
    );
  }
}
