import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/data/models/local/common_recipe/common_recipe.dart';
import 'package:flavormate/presentation/common/widgets/f_card.dart';
import 'package:flavormate/presentation/common/widgets/f_guide_card/f_guide_card.dart';
import 'package:flavormate/presentation/common/widgets/f_guide_card/f_guide_card_carousel.dart';
import 'package:flavormate/presentation/common/widgets/f_recipe/dialogs/f_recipe_guided_dialog_action_row.dart';
import 'package:flavormate/presentation/common/widgets/f_recipe/widgets/f_recipe_durations_table.dart';
import 'package:flavormate/presentation/common/widgets/f_recipe/widgets/f_recipe_ingredient_group_list.dart';
import 'package:flavormate/presentation/common/widgets/f_text/f_text.dart';
import 'package:flavormate/presentation/common/widgets/f_wrap.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:sliding_panel_kit/sliding_panel_kit.dart';

class FRecipeGuidedMobileDialog extends StatelessWidget {
  final FGuideCard currentStep;
  final bool enablePreviousBtn;
  final bool enableNextBtn;

  final double containerHeight;
  final double cardHeight;

  final VoidCallback onTapPrevious;
  final VoidCallback onTapNext;
  final int slideDirection;

  final CommonRecipe recipe;
  final double amountFactor;

  final bool durationCardActive;
  final VoidCallback onDurationCard;
  final bool ingredientCardActive;
  final VoidCallback onIngredientCard;

  const FRecipeGuidedMobileDialog({
    super.key,
    required this.currentStep,
    required this.enablePreviousBtn,
    required this.enableNextBtn,
    required this.containerHeight,
    required this.cardHeight,
    required this.onTapPrevious,
    required this.onTapNext,
    required this.slideDirection,
    required this.recipe,
    required this.amountFactor,
    required this.durationCardActive,
    required this.onDurationCard,
    required this.ingredientCardActive,
    required this.onIngredientCard,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: .expand,
      children: [
        Align(
          alignment: .topCenter,
          child: SizedBox(
            height: containerHeight,
            child: Center(
              child: Column(
                spacing: PADDING,
                mainAxisSize: .min,
                children: [
                  FGuideCardCarousel(
                    currentKey: currentStep.key,
                    slideDirection: slideDirection,
                    height: cardHeight,
                    child: currentStep,
                  ),
                  FRecipeGuidedDialogActionRow(
                    enablePreviousBtn: enablePreviousBtn,
                    enableNextBtn: enableNextBtn,
                    onTapPrevious: onTapPrevious,
                    onTapNext: onTapNext,
                  ),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(PADDING),
          child: SlidingPanelBuilder(
            handle: const SlidingPanelHandle(),
            snapConfig: SlidingPanelSnapConfig(extents: [1]),
            builder: (context, handle) {
              return FCard(
                padding: PADDING / 2,
                child: Column(
                  children: [
                    ?handle,
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          spacing: PADDING,
                          children: [
                            FWrap(
                              children: [
                                if (!durationCardActive)
                                  ActionChip(
                                    avatar: const Icon(MdiIcons.clock),
                                    label: Text(
                                      context.l10n.f_recipe_durations,
                                    ),
                                    onPressed: onDurationCard,
                                  ),
                                if (!ingredientCardActive)
                                  ActionChip(
                                    avatar: const Icon(MdiIcons.foodVariant),
                                    label: Text(
                                      context.l10n.f_recipe_ingredients,
                                    ),
                                    onPressed: onIngredientCard,
                                  ),
                              ],
                            ),

                            if (durationCardActive)
                              FCard(
                                color: context.colorScheme.primaryContainer,
                                child: Column(
                                  spacing: PADDING,
                                  children: [
                                    Row(
                                      mainAxisAlignment: .spaceBetween,
                                      children: [
                                        FText(
                                          context.l10n.f_recipe_durations,
                                          style: .titleLarge,
                                        ),
                                        IconButton(
                                          onPressed: onDurationCard,
                                          icon: const Icon(MdiIcons.close),
                                        ),
                                      ],
                                    ),
                                    FRecipeDurationsTable(
                                      prepTime: recipe.prepTime,
                                      cookTime: recipe.cookTime,
                                      restTime: recipe.restTime,
                                    ),
                                  ],
                                ),
                              ),
                            if (ingredientCardActive)
                              FCard(
                                color: context.colorScheme.primaryContainer,
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: .spaceBetween,
                                      children: [
                                        FText(
                                          context.l10n.f_recipe_ingredients,
                                          style: .titleLarge,
                                        ),
                                        IconButton(
                                          onPressed: onIngredientCard,
                                          icon: const Icon(MdiIcons.close),
                                        ),
                                      ],
                                    ),
                                    FRecipeIngredientGroupList(
                                      compact: true,
                                      ingredientGroups: recipe.ingredientGroups,
                                      decreaseServing: null,
                                      increaseServing: null,
                                      amountFactor: amountFactor,
                                      newAmount:
                                          amountFactor * recipe.serving.amount,
                                      servingLabel: recipe.serving.label,
                                      checkable: true,
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
