import 'package:flavormate/components/recipe/recipe_description.dart';
import 'package:flavormate/components/recipe/recipe_durations.dart';
import 'package:flavormate/components/recipe/recipe_ingredients.dart';
import 'package:flavormate/components/recipe/recipe_instructions.dart';
import 'package:flavormate/components/recipe/recipe_nutrition_mobile.dart';
import 'package:flavormate/components/recipe/recipe_title.dart';
import 'package:flavormate/components/t_carousel.dart';
import 'package:flavormate/components/t_column.dart';
import 'package:flavormate/components/t_image.dart';
import 'package:flavormate/components/t_slide.dart';
import 'package:flavormate/extensions/e_build_context.dart';
import 'package:flavormate/models/recipe/nutrition/nutrition.dart';
import 'package:flavormate/models/recipe/recipe.dart';
import 'package:flavormate/riverpod/shared_preferences/p_server.dart';
import 'package:flavormate/utils/constants.dart';
import 'package:flutter/material.dart';

class PublicRecipePageMobile extends StatelessWidget {
  final Recipe recipe;
  final double servingFactor;
  final Nutrition? nutrition;

  final VoidCallback decreaseServing;
  final VoidCallback increaseServing;
  final VoidCallback addToBring;

  const PublicRecipePageMobile({
    super.key,
    required this.recipe,
    required this.servingFactor,
    required this.decreaseServing,
    required this.increaseServing,
    required this.addToBring,
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
                        imageSrc: file.fullPath ??
                            file.path(context.read(pServerProvider)!),
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
