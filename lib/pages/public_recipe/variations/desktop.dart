import 'package:flavormate/components/recipe/recipe_description.dart';
import 'package:flavormate/components/recipe/recipe_durations.dart';
import 'package:flavormate/components/recipe/recipe_ingredients.dart';
import 'package:flavormate/components/recipe/recipe_instructions.dart';
import 'package:flavormate/components/recipe/recipe_nutrition_desktop.dart';
import 'package:flavormate/components/recipe/recipe_title.dart';
import 'package:flavormate/components/t_carousel.dart';
import 'package:flavormate/components/t_column.dart';
import 'package:flavormate/components/t_image.dart';
import 'package:flavormate/components/t_row.dart';
import 'package:flavormate/components/t_slide.dart';
import 'package:flavormate/extensions/e_build_context.dart';
import 'package:flavormate/models/recipe/nutrition/nutrition.dart';
import 'package:flavormate/models/recipe/recipe.dart';
import 'package:flavormate/riverpod/shared_preferences/p_server.dart';
import 'package:flutter/material.dart';

class PublicRecipePageDesktop extends StatelessWidget {
  final Recipe recipe;
  final double servingFactor;
  final Nutrition? nutrition;

  final VoidCallback decreaseServing;
  final VoidCallback increaseServing;
  final VoidCallback addToBring;

  const PublicRecipePageDesktop({
    super.key,
    required this.recipe,
    required this.servingFactor,
    required this.decreaseServing,
    required this.increaseServing,
    required this.addToBring,
    required this.nutrition,
  });

  static const _widgetWidth = 450.0;

  @override
  Widget build(BuildContext context) {
    return TColumn(
      children: [
        IntrinsicHeight(
          child: TRow(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (recipe.coverUrl != null)
                Expanded(
                  child: TCarousel(
                    height: 20,
                    slides: recipe.files
                        .map(
                          (file) => TSlide(
                            imageSrc: file.path(context.read(pServerProvider)!),
                            type: TImageType.network,
                          ),
                        )
                        .toList(),
                  ),
                ),
              Expanded(
                child: TColumn(
                  children: [
                    RecipeTitle(title: recipe.label),
                    if (recipe.description != null)
                      RecipeDescription(description: recipe.description!),
                    SizedBox(
                      width: _widgetWidth,
                      child: RecipeDurations(
                        prepTime: recipe.prepTime,
                        cookTime: recipe.cookTime,
                        restTime: recipe.restTime,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        if (nutrition != null)
          RecipeNutritionDesktop(
            nutrition: nutrition,
            serving: recipe.serving,
            servingFactor: servingFactor,
          ),
        IntrinsicHeight(
          child: TRow(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: RecipeIngredients(
                  ingredientGroups: recipe.ingredientGroups,
                  decreaseServing: decreaseServing,
                  increaseServing: increaseServing,
                  factor: servingFactor,
                  serving: recipe.serving,
                ),
              ),
              Expanded(
                child: RecipeInstructions(
                  instructionGroups: recipe.instructionGroups,
                  factor: servingFactor,
                  serving: recipe.serving,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
