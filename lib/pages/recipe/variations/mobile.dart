import 'package:flavormate/components/recipe/bring_button.dart';
import 'package:flavormate/components/recipe/recipe_decription.dart';
import 'package:flavormate/components/recipe/recipe_durations.dart';
import 'package:flavormate/components/recipe/recipe_ingredients.dart';
import 'package:flavormate/components/recipe/recipe_instructions.dart';
import 'package:flavormate/components/recipe/recipe_nutrition.dart';
import 'package:flavormate/components/recipe/recipe_title.dart';
import 'package:flavormate/components/t_carousel.dart';
import 'package:flavormate/components/t_column.dart';
import 'package:flavormate/components/t_icon_button.dart';
import 'package:flavormate/components/t_image.dart';
import 'package:flavormate/components/t_slide.dart';
import 'package:flavormate/extensions/e_build_context.dart';
import 'package:flavormate/l10n/generated/l10n.dart';
import 'package:flavormate/models/recipe/nutrition/nutrition.dart';
import 'package:flavormate/models/recipe/recipe.dart';
import 'package:flavormate/riverpod/shared_preferences/p_server.dart';
import 'package:flavormate/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';

class RecipePageMobile extends StatelessWidget {
  final Recipe recipe;
  final bool isBringEnabled;
  final double servingFactor;
  final Nutrition? nutrition;

  final VoidCallback decreaseServing;
  final VoidCallback increaseServing;
  final VoidCallback addToBring;
  final VoidCallback addBookmark;

  const RecipePageMobile({
    super.key,
    required this.recipe,
    required this.isBringEnabled,
    required this.servingFactor,
    required this.decreaseServing,
    required this.increaseServing,
    required this.addToBring,
    required this.addBookmark,
    required this.nutrition,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (recipe.coverUrl != null)
          AspectRatio(
            aspectRatio: 16 / 9,
            child: TCarousel(
                slides: recipe.files
                    .map(
                      (file) => TSlide(
                        imageSrc: file.path(context.read(pServerProvider)!),
                        type: TImageType.network,
                      ),
                    )
                    .toList()),
          ),
        if (recipe.coverUrl != null) const SizedBox(height: PADDING),
        TColumn(
          children: [
            RecipeTitle(title: recipe.label),
            if (recipe.description != null)
              RecipeDescription(description: recipe.description!),
            const Divider(),
            if (isBringEnabled) BringButton(onPressed: addToBring),
            TIconButton(
              onPressed: addBookmark,
              icon: MdiIcons.bookmark,
              label: L10n.of(context).c_recipe_bookmark,
            ),
            const Divider(),
            RecipeDurations(
              prepTime: recipe.prepTime,
              cookTime: recipe.cookTime,
              restTime: recipe.restTime,
            ),
            if (nutrition != null)
              TColumn(
                children: [
                  const Divider(),
                  RecipeNutrition(
                    nutrition: nutrition,
                    factor: servingFactor,
                    serving: recipe.serving,
                  )
                ],
              ),
            const Divider(),
            RecipeIngredients(
              ingredientGroups: recipe.ingredientGroups,
              decreaseServing: decreaseServing,
              increaseServing: increaseServing,
              factor: servingFactor,
              serving: recipe.serving,
            ),
            const Divider(),
            RecipeInstructions(
              instructionGroups: recipe.instructionGroups,
              factor: servingFactor,
              serving: recipe.serving,
            ),
          ],
        ),
      ],
    );
  }
}
