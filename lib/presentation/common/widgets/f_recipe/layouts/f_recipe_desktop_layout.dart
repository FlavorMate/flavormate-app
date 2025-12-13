import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/data/models/local/common_recipe/common_nutrition.dart';
import 'package:flavormate/data/models/local/common_recipe/common_recipe.dart';
import 'package:flavormate/data/models/shared/enums/image_resolution.dart';
import 'package:flavormate/presentation/common/widgets/f_carousel/f_carousel.dart';
import 'package:flavormate/presentation/common/widgets/f_icon_button.dart';
import 'package:flavormate/presentation/common/widgets/f_recipe/layouts/f_recipe_nutrition_desktop_layout.dart';
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
import 'package:flavormate/presentation/common/widgets/f_wrap.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';

class FRecipeDesktopLayout extends StatelessWidget {
  static const double _verticalWidth = PADDING * 2;

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

  const FRecipeDesktopLayout({
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
            IntrinsicHeight(
              child: Row(
                spacing: PADDING,
                children: [
                  if (recipe.files.isNotEmpty)
                    Expanded(
                      child: SizedBox(
                        height: 286,
                        child: FCarousel(
                          data: recipe.files,
                          coverSelector: (image, resolution) =>
                              image.url(resolution),
                          onTap: (s) => context.showFullscreenImage(
                            s.url(ImageResolution.Original),
                          ),
                          onShowAll: showAllFiles,
                        ),
                      ),
                    ),
                  Expanded(
                    child: Column(
                      spacing: PADDING,
                      mainAxisAlignment: .spaceEvenly,
                      children: [
                        FRecipeTitle(title: recipe.label),

                        if (recipe.description != null)
                          FRecipeDescription(description: recipe.description!),

                        FRecipeDurations(
                          prepTime: recipe.prepTime,
                          cookTime: recipe.cookTime,
                          restTime: recipe.restTime,
                        ),

                        if (enableBookmark || enableBring)
                          FWrap(
                            children: [
                              if (enableBring)
                                SizedBox(
                                  width: BUTTON_WIDTH,
                                  child: FRecipeBringButton(
                                    onPressed: addToBring!,
                                  ),
                                ),
                              if (enableBookmark)
                                SizedBox(
                                  width: BUTTON_WIDTH,
                                  child: FIconButton(
                                    onPressed: addBookmark,
                                    icon: MdiIcons.bookmark,
                                    label: context
                                        .l10n
                                        .f_recipe_layout__save_recipe,
                                  ),
                                ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const Divider(),
            IntrinsicHeight(
              child: Row(
                spacing: PADDING,
                children: [
                  Expanded(
                    flex: 2,
                    child: FRecipeIngredientGroupList(
                      ingredientGroups: recipe.ingredientGroups,
                      decreaseServing: decreaseServing,
                      increaseServing: increaseServing,
                      amountFactor: amountFactor,
                      newAmount: newAmount,
                      servingLabel: recipe.serving.label,
                    ),
                  ),
                  const VerticalDivider(width: _verticalWidth),
                  Expanded(
                    flex: 2,
                    child: FRecipeInstructionGroupList(
                      instructionGroups: recipe.instructionGroups,
                      amountFactor: amountFactor,
                    ),
                  ),
                ],
              ),
            ),
            if (nutrition != null) ...[
              const Divider(),
              FRecipeNutritionDesktopLayout(
                nutrition: nutrition,
                amountFactor: amountFactor,
                servingLabel: recipe.serving.label,
              ),
            ],
            const Divider(),
            IntrinsicHeight(
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: FRecipeCategories(
                      course: recipe.course,
                      diet: recipe.diet,
                      readOnly: readOnly,
                      categories: recipe.categories,
                    ),
                  ),
                  if (recipe.tags.isNotEmpty) ...[
                    const VerticalDivider(width: _verticalWidth),
                    Expanded(
                      flex: 1,
                      child: FRecipeTags(readOnly: readOnly, tags: recipe.tags),
                    ),
                  ],
                ],
              ),
            ),
            const Divider(),
            IntrinsicHeight(
              child: Row(
                children: [
                  if (enableReview && setRating != null) ...[
                    Expanded(
                      child: FRecipeRatings(
                        recipeId: recipe.id,
                        onRatingTap: setRating!,
                      ),
                    ),

                    const VerticalDivider(width: _verticalWidth),
                  ],
                  Expanded(
                    child: FRecipePublished(
                      account: recipe.ownedBy,
                      readOnly: readOnly,
                      createdOn: recipe.createdOn,
                      url: recipe.url,
                      version: recipe.version,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
