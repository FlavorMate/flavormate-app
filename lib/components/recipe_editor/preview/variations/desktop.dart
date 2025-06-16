import 'package:flavormate/components/recipe/recipe_description.dart';
import 'package:flavormate/components/recipe/recipe_durations.dart';
import 'package:flavormate/components/recipe/recipe_title.dart';
import 'package:flavormate/components/recipe_editor/preview/preview_ingredients.dart';
import 'package:flavormate/components/recipe_editor/preview/preview_instructions.dart';
import 'package:flavormate/components/t_carousel.dart';
import 'package:flavormate/components/t_column.dart';
import 'package:flavormate/components/t_image.dart';
import 'package:flavormate/components/t_row.dart';
import 'package:flavormate/components/t_slide.dart';
import 'package:flavormate/models/file/file.dart';
import 'package:flavormate/models/recipe_draft/recipe_draft.dart';
import 'package:flutter/material.dart';

class PreviewDesktop extends StatelessWidget {
  final List<File> images;
  final RecipeDraft recipe;

  const PreviewDesktop({super.key, required this.images, required this.recipe});

  static const _widgetWidth = 450.0;

  @override
  Widget build(BuildContext context) {
    return TColumn(
      children: [
        IntrinsicHeight(
          child: TRow(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: TCarousel(
                  height: 20,
                  slides: images
                      .map(
                        (file) => TSlide(
                          imageSrc: file.content!.split(',')[1],
                          type: TImageType.memory,
                        ),
                      )
                      .toList(),
                ),
              ),
              Expanded(
                child: TColumn(
                  children: [
                    RecipeTitle(title: recipe.label!),
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
              ),
            ],
          ),
        ),
        IntrinsicHeight(
          child: TRow(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: PreviewIngredients(
                  ingredientGroups: recipe.ingredientGroups,
                  serving: recipe.serving,
                ),
              ),
              Expanded(
                child: PreviewInstructions(
                  instructionGroups: recipe.instructionGroups,
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
