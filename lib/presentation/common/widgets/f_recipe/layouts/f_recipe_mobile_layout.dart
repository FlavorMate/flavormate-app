import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/data/models/local/common_recipe/common_nutrition.dart';
import 'package:flavormate/data/models/local/common_recipe/common_recipe.dart';
import 'package:flavormate/data/models/shared/enums/image_resolution.dart';
import 'package:flavormate/presentation/common/widgets/f_carousel/f_carousel.dart';
import 'package:flavormate/presentation/common/widgets/f_icon_button.dart';
import 'package:flavormate/presentation/common/widgets/f_recipe/layouts/f_recipe_nutrition_mobile_layout.dart';
import 'package:flavormate/presentation/common/widgets/f_recipe/widgets/f_recipe_bring_button.dart';
import 'package:flavormate/presentation/common/widgets/f_recipe/widgets/f_recipe_categories.dart';
import 'package:flavormate/presentation/common/widgets/f_recipe/widgets/f_recipe_description.dart';
import 'package:flavormate/presentation/common/widgets/f_recipe/widgets/f_recipe_durations.dart';
import 'package:flavormate/presentation/common/widgets/f_recipe/widgets/f_recipe_ingredient_group_list.dart';
import 'package:flavormate/presentation/common/widgets/f_recipe/widgets/f_recipe_instruction_group_list.dart';
import 'package:flavormate/presentation/common/widgets/f_recipe/widgets/f_recipe_published.dart';
import 'package:flavormate/presentation/common/widgets/f_recipe/widgets/f_recipe_ratings.dart';
import 'package:flavormate/presentation/common/widgets/f_recipe/widgets/f_recipe_tags.dart';
import 'package:flavormate/presentation/common/widgets/f_recipe/widgets/f_recipe_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';

class FRecipeMobileLayout extends StatelessWidget {
  final CommonRecipe recipe;
  final bool enableBookmark;
  final bool enableBring;
  final bool enableReview;
  final bool readOnly;
  final bool hasFab;

  final VoidCallback showAllFiles;

  final VoidCallback? addToBring;
  final VoidCallback? addBookmark;
  final Function(double?)? setRating;

  final CommonNutrition? nutrition;

  final double amountFactor;
  final double newAmount;

  final VoidCallback decreaseServing;
  final VoidCallback increaseServing;

  const FRecipeMobileLayout({
    super.key,
    required this.recipe,
    required this.enableBookmark,
    required this.enableBring,
    required this.enableReview,
    required this.readOnly,
    required this.hasFab,
    required this.showAllFiles,
    required this.addToBring,
    required this.addBookmark,
    required this.setRating,
    required this.nutrition,
    required this.amountFactor,
    required this.newAmount,
    required this.decreaseServing,
    required this.increaseServing,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(PADDING),
        child: Column(
          spacing: PADDING,
          children: [
            if (recipe.files.isNotEmpty)
              FCarousel(
                data: recipe.files,
                coverSelector: (image, resolution) => image.url(resolution),
                onTap: (s) => context.showFullscreenImage(
                  s.url(ImageResolution.Original),
                ),
                onShowAll: showAllFiles,
              ),

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
                label: context.l10n.f_recipe_layout__save_recipe,
              ),

            const Divider(),
            FRecipeDurations(
              prepTime: recipe.prepTime,
              cookTime: recipe.cookTime,
              restTime: recipe.restTime,
            ),

            if (nutrition != null) ...[
              const Divider(),
              FRecipeNutritionMobileLayout(
                nutrition: nutrition,
                amountFactor: amountFactor,
                servingLabel: recipe.serving.label,
              ),
            ],

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

            ...[
              const Divider(),
              FRecipeCategories(
                course: recipe.course,
                diet: recipe.diet,
                readOnly: readOnly,
                categories: recipe.categories,
              ),
            ],
            if (recipe.tags.isNotEmpty) ...[
              const Divider(),
              FRecipeTags(
                readOnly: readOnly,
                tags: recipe.tags,
              ),
            ],
            if (enableReview && setRating != null) ...[
              const Divider(),
              FRecipeRatings(
                recipeId: recipe.id,
                onRatingTap: setRating!,
              ),
            ],
            const Divider(),
            FRecipePublished(
              account: recipe.ownedBy,
              readOnly: readOnly,
              createdOn: recipe.createdOn,
              version: recipe.version,
              url: recipe.url,
            ),
            if (hasFab) const SizedBox(height: 56),
          ],
        ),
      ),
    );
  }
}
