import 'dart:ui';

import 'package:collection/collection.dart';
import 'package:flavormate/core/constants/breakpoint_constants.dart';
import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/data/models/local/common_recipe/common_recipe.dart';
import 'package:flavormate/presentation/common/dialogs/f_alert_dialog.dart';
import 'package:flavormate/presentation/common/widgets/f_app_bar.dart';
import 'package:flavormate/presentation/common/widgets/f_button.dart';
import 'package:flavormate/presentation/common/widgets/f_guide_card/f_guide_card.dart';
import 'package:flavormate/presentation/common/widgets/f_guide_card/f_guide_card_complete.dart';
import 'package:flavormate/presentation/common/widgets/f_guide_card/f_guide_card_end.dart';
import 'package:flavormate/presentation/common/widgets/f_guide_card/f_guide_card_instruction.dart';
import 'package:flavormate/presentation/common/widgets/f_recipe/dialogs/f_recipe_guided_desktop_dialog.dart';
import 'package:flavormate/presentation/common/widgets/f_recipe/dialogs/f_recipe_guided_dialog_action_row.dart';
import 'package:flavormate/presentation/common/widgets/f_recipe/dialogs/f_recipe_guided_mobile_dialog.dart';
import 'package:flavormate/presentation/common/widgets/f_text/f_text.dart';
import 'package:flavormate/presentation/common/widgets/f_tile_group/f_tile.dart';
import 'package:flavormate/presentation/common/widgets/f_tile_group/f_tile_group.dart';
import 'package:flavormate/presentation/common/widgets/f_tile_group/f_tile_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sliding_panel_kit/sliding_panel_kit.dart';

class FRecipeGuidedDialog extends ConsumerStatefulWidget {
  final CommonRecipe recipe;
  final double amountFactor;

  const FRecipeGuidedDialog({
    super.key,
    required this.recipe,
    required this.amountFactor,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FRecipeGuidedDialog();
}

class _FRecipeGuidedDialog extends ConsumerState<FRecipeGuidedDialog> {
  int index = 0;
  int _slideDirection = 1;
  List<FGuideCard> steps = [];

  double _fontSize = 20.0;

  bool get _enableDecreaseFont => _fontSize > 16;

  static const _minCardHeight = 150.0;
  static const _maxCardHeight = 450.0;

  bool get enablePreviousBtn => index > 0;

  bool get enableNextBtn => index < steps.length - 1;

  bool _durationCardActive = true;
  bool _ingredientCardActive = true;

  bool get _showCardShortcuts => !_durationCardActive || !_ingredientCardActive;

  @override
  void initState() {
    setupInstructions();

    super.initState();
  }

  void setupInstructions() {
    steps.clear();

    final groups = widget.recipe.instructionGroups;
    for (final (groupIndex, group)
        in groups.sortedBy((it) => it.index).indexed) {
      for (final (stepIndex, step)
          in group.instructions.sortedBy((it) => it.index).indexed) {
        final guide = FGuideCardInstruction(
          id: step.id,
          content: step.format(widget.amountFactor),
          currentStepLabel: group.label,
          currentGroup: groupIndex + 1,
          lastGroup: groups.length,
          currentStep: stepIndex + 1,
          lastStep: group.instructions.length,
          fontSize: _fontSize,
        );

        steps.add(guide);
      }

      if (groups.length > 1) {
        steps.add(
          FGuideCardComplete(
            id: '${widget.recipe.id}_${groupIndex}_complete',
            label: group.label,
            fontSize: _fontSize,
          ),
        );
      }
    }

    steps.add(
      FGuideCardEnd(
        id: '${widget.recipe.id}_end',
        label: widget.recipe.label,
        fontSize: _fontSize,
      ),
    );
  }

  void onTapPrevious() {
    if (index - 1 >= 0) {
      setState(() {
        _slideDirection = -1;
        index--;
      });
    }
  }

  void onTapNext() {
    if (index + 1 < steps.length) {
      setState(() {
        _slideDirection = 1;
        index++;
      });
    }
  }

  void decreaseFont() {
    if (!_enableDecreaseFont) return;
    setState(() {
      _fontSize -= 4;
      setupInstructions();
    });
  }

  void increaseFont() {
    setState(() {
      _fontSize += 4;
      setupInstructions();
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentStep = steps[index];

    final useDesktop = FBreakpoint.gt(context, FBreakpoint.md);

    return Dialog.fullscreen(
      child: Scaffold(
        appBar: FAppBar(
          title: widget.recipe.label,
          scrollController: null,
          actions: [
            IconButton(
              onPressed: showOptions,
              icon: const Icon(MdiIcons.dotsVertical),
            ),
          ],
        ),
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final fullHeight = constraints.maxHeight;

              final containerHeight =
                  fullHeight -
                  PADDING -
                  const SlidingPanelHandle().preferredSize.height;

              final contentHeight =
                  containerHeight -
                  PADDING -
                  FRecipeGuidedDialogActionRow.HEIGHT;

              final cardHeight = clampDouble(
                contentHeight,
                _minCardHeight,
                _maxCardHeight,
              );

              if (contentHeight < _minCardHeight) {
                return Center(
                  child: FText(
                    context.l10n.f_recipe_guided_dialog__not_available,
                    style: .titleLarge,
                  ),
                );
              }

              if (useDesktop) {
                return SizedBox(
                  height: fullHeight,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: PADDING,
                      vertical: PADDING,
                    ),
                    child: FRecipeGuidedDesktopDialog(
                      currentStep: currentStep,
                      enablePreviousBtn: enablePreviousBtn,
                      enableNextBtn: enableNextBtn,
                      containerHeight: containerHeight,
                      cardHeight: cardHeight,
                      onTapPrevious: onTapPrevious,
                      onTapNext: onTapNext,
                      slideDirection: _slideDirection,
                      recipe: widget.recipe,
                      amountFactor: widget.amountFactor,
                      durationCardActive: _durationCardActive,
                      onDurationCard: toggleDurationCard,
                      ingredientCardActive: _ingredientCardActive,
                      onIngredientCard: toggleIngredientsCard,
                    ),
                  ),
                );
              } else {
                return FRecipeGuidedMobileDialog(
                  currentStep: currentStep,
                  enablePreviousBtn: enablePreviousBtn,
                  enableNextBtn: enableNextBtn,
                  containerHeight: containerHeight,
                  cardHeight: cardHeight,
                  onTapPrevious: onTapPrevious,
                  onTapNext: onTapNext,
                  slideDirection: _slideDirection,
                  recipe: widget.recipe,
                  amountFactor: widget.amountFactor,
                  durationCardActive: _durationCardActive,
                  onDurationCard: toggleDurationCard,
                  ingredientCardActive: _ingredientCardActive,
                  onIngredientCard: toggleIngredientsCard,
                );
              }
            },
          ),
        ),
        bottomNavigationBar: _showCardShortcuts && useDesktop
            ? SafeArea(
                minimum: const .only(bottom: PADDING),
                child: SizedBox(
                  height: 48,
                  child: Center(
                    child: SingleChildScrollView(
                      scrollDirection: .horizontal,
                      child: Row(
                        spacing: PADDING,
                        mainAxisSize: .min,
                        children: [
                          if (!_durationCardActive)
                            FButton(
                              width: 150,
                              leading: const Icon(MdiIcons.clock),
                              label: context.l10n.f_recipe_durations,
                              onPressed: toggleDurationCard,
                            ),
                          if (!_ingredientCardActive)
                            FButton(
                              width: 150,
                              leading: const Icon(MdiIcons.foodVariant),
                              label: context.l10n.f_recipe_ingredients,
                              onPressed: toggleIngredientsCard,
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            : null,
      ),
    );
  }

  void showOptions() {
    showDialog(
      context: context,
      builder: (context) {
        return FAlertDialog(
          title: context.l10n.f_recipe_guided_dialog__options__title,
          negativeLabel: context.l10n.btn_close,
          child: Column(
            mainAxisSize: .min,
            children: [
              FTileGroup(
                title: context.l10n.f_recipe_guided_dialog__options__font_title,
                items: [
                  FTile(
                    leading: const FTileIcon(
                      icon: MdiIcons.formatFontSizeDecrease,
                    ),
                    label: context
                        .l10n
                        .f_recipe_guided_dialog__options__decrease_font__title,
                    subLabel: null,
                    onTap: decreaseFont,
                  ),
                  FTile(
                    leading: const FTileIcon(
                      icon: MdiIcons.formatFontSizeIncrease,
                    ),
                    label: context
                        .l10n
                        .f_recipe_guided_dialog__options__increase_font__title,
                    subLabel: null,
                    onTap: increaseFont,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void toggleDurationCard() {
    setState(() {
      _durationCardActive = !_durationCardActive;
    });
  }

  void toggleIngredientsCard() {
    setState(() {
      _ingredientCardActive = !_ingredientCardActive;
    });
  }
}
