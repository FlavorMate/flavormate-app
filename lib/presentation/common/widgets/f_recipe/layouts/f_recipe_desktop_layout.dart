import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/data/models/local/common_recipe/common_nutrition.dart';
import 'package:flavormate/data/models/local/common_recipe/common_recipe.dart';
import 'package:flavormate/generated/l10n/l10n.dart';
import 'package:flavormate/presentation/common/widgets/f_icon_button.dart';
import 'package:flavormate/presentation/common/widgets/f_recipe/layouts/f_recipe_nutrition_desktop_layout.dart';
import 'package:flavormate/presentation/common/widgets/f_recipe/widgets/f_recipe_bring_button.dart';
import 'package:flavormate/presentation/common/widgets/f_recipe/widgets/f_recipe_description.dart';
import 'package:flavormate/presentation/common/widgets/f_recipe/widgets/f_recipe_durations.dart';
import 'package:flavormate/presentation/common/widgets/f_recipe/widgets/f_recipe_ingredient_group_list.dart';
import 'package:flavormate/presentation/common/widgets/f_recipe/widgets/f_recipe_instruction_group_list.dart';
import 'package:flavormate/presentation/common/widgets/f_recipe/widgets/f_recipe_title.dart';
import 'package:flavormate/presentation/common/widgets/f_wrap.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';

class FRecipeDesktopLayout extends StatelessWidget {
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

  const FRecipeDesktopLayout({
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
      spacing: PADDING,
      children: [
        FRecipeTitle(title: recipe.label),
        if (recipe.description != null)
          FRecipeDescription(description: recipe.description!),

        const Divider(),
        FRecipeDurations(
          prepTime: recipe.prepTime,
          cookTime: recipe.cookTime,
          restTime: recipe.restTime,
        ),
        if (enableBring || enableBookmark) ...[
          const Divider(),
          FWrap(
            children: [
              if (enableBring)
                SizedBox(
                  width: BUTTON_WIDTH,
                  child: FRecipeBringButton(onPressed: addToBring!),
                ),
              if (enableBookmark)
                SizedBox(
                  width: BUTTON_WIDTH,
                  child: FIconButton(
                    onPressed: addBookmark!,
                    icon: MdiIcons.bookmark,
                    label: L10n.of(
                      context,
                    ).f_recipe_layout__save_recipe,
                  ),
                ),
            ],
          ),
        ],
        const Divider(),
        if (nutrition != null)
          FRecipeNutritionDesktopLayout(
            nutrition: nutrition!,
            amountFactor: amountFactor,
            servingLabel: recipe.serving.label,
          ),
        IntrinsicHeight(
          child: Row(
            spacing: PADDING,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: FRecipeIngredientGroupList(
                  ingredientGroups: recipe.ingredientGroups,
                  decreaseServing: decreaseServing,
                  increaseServing: increaseServing,
                  amountFactor: amountFactor,
                  newAmount: newAmount,
                  servingLabel: recipe.serving.label,
                ),
              ),
              Expanded(
                child: FRecipeInstructionGroupList(
                  instructionGroups: recipe.instructionGroups,
                  amountFactor: amountFactor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
