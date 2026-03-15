import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/data/models/local/common_recipe/common_recipe.dart';
import 'package:flavormate/presentation/common/widgets/f_card.dart';
import 'package:flavormate/presentation/common/widgets/f_guide_card/f_guide_card.dart';
import 'package:flavormate/presentation/common/widgets/f_guide_card/f_guide_card_carousel.dart';
import 'package:flavormate/presentation/common/widgets/f_recipe/dialogs/f_recipe_guided_dialog_action_row.dart';
import 'package:flavormate/presentation/common/widgets/f_recipe/widgets/f_recipe_ingredient_group_list.dart';
import 'package:flutter/material.dart';
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
        SlidingPanelBuilder(
          handle: const SlidingPanelHandle(),
          snapConfig: SlidingPanelSnapConfig(extents: [1]),
          builder: (context, handle) {
            return FCard(
              padding: 8,
              child: Column(
                children: [
                  ?handle,
                  Expanded(
                    child: FRecipeIngredientGroupList(
                      compact: true,
                      ingredientGroups: recipe.ingredientGroups,
                      decreaseServing: null,
                      increaseServing: null,
                      amountFactor: amountFactor,
                      newAmount: amountFactor * recipe.serving.amount,
                      servingLabel: recipe.serving.label,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
