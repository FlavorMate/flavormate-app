import 'package:flavormate/components/recipe/recipe_description.dart';
import 'package:flavormate/components/recipe/recipe_durations.dart';
import 'package:flavormate/components/recipe/recipe_title.dart';
import 'package:flavormate/components/recipe_editor/preview/preview_ingredients.dart';
import 'package:flavormate/components/recipe_editor/preview/preview_instructions.dart';
import 'package:flavormate/components/t_carousel.dart';
import 'package:flavormate/components/t_column.dart';
import 'package:flavormate/components/t_image.dart';
import 'package:flavormate/components/t_slide.dart';
import 'package:flavormate/models/file/file.dart';
import 'package:flavormate/models/recipe_draft/recipe_draft.dart';
import 'package:flavormate/utils/constants.dart';
import 'package:flutter/material.dart';

class PreviewMobile extends StatelessWidget {
  final List<File> images;
  final RecipeDraft recipe;

  const PreviewMobile({
    super.key,
    required this.images,
    required this.recipe,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (images.isNotEmpty)
          AspectRatio(
            aspectRatio: 16 / 9,
            child: TCarousel(
                slides: images
                    .map(
                      (file) => TSlide(
                        imageSrc: file.content!.split(',')[1],
                        type: TImageType.memory,
                      ),
                    )
                    .toList()),
          ),
        if (images.isNotEmpty) const SizedBox(height: PADDING),
        TColumn(
          children: [
            RecipeTitle(title: recipe.label!),
            if (recipe.description != null)
              RecipeDescription(description: recipe.description!),
            const Divider(),
            RecipeDurations(
              prepTime: recipe.prepTime,
              cookTime: recipe.cookTime,
              restTime: recipe.restTime,
            ),
            const Divider(),
            PreviewIngredients(
              ingredientGroups: recipe.ingredientGroups,
              serving: recipe.serving,
            ),
            const Divider(),
            PreviewInstructions(
              instructionGroups: recipe.instructionGroups,
              serving: recipe.serving,
            ),
          ],
        ),
      ],
    );
  }
}
