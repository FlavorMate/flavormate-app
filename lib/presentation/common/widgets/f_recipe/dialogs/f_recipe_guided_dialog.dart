import 'dart:ui';

import 'package:flavormate/core/constants/breakpoint_constants.dart';
import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/data/models/local/common_recipe/common_recipe.dart';
import 'package:flavormate/presentation/common/widgets/f_app_bar.dart';
import 'package:flavormate/presentation/common/widgets/f_button.dart';
import 'package:flavormate/presentation/common/widgets/f_card.dart';
import 'package:flavormate/presentation/common/widgets/f_guide_card/f_guide_card.dart';
import 'package:flavormate/presentation/common/widgets/f_guide_card/f_guide_card_carousel.dart';
import 'package:flavormate/presentation/common/widgets/f_guide_card/f_guide_card_complete.dart';
import 'package:flavormate/presentation/common/widgets/f_guide_card/f_guide_card_end.dart';
import 'package:flavormate/presentation/common/widgets/f_guide_card/f_guide_card_instruction.dart';
import 'package:flavormate/presentation/common/widgets/f_recipe/widgets/f_recipe_ingredient_group_list.dart';
import 'package:flavormate/presentation/common/widgets/f_responsive.dart';
import 'package:flavormate/presentation/common/widgets/f_text/f_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
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

  double _fontSize = 16.0;

  bool get _enableDecreaseFont => _fontSize > 16;

  static const _minCardHeight = 150.0;
  static const _maxCardHeight = 450.0;

  @override
  void initState() {
    setupInstructions();

    super.initState();
  }

  void setupInstructions() {
    steps.clear();

    final groups = widget.recipe.instructionGroups;
    for (final (groupIndex, group) in groups.indexed) {
      for (final (stepIndex, step) in group.instructions.indexed) {
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

  void previousItem() {
    if (index - 1 >= 0) {
      setState(() {
        _slideDirection = -1;
        index--;
      });
    }
  }

  void nextItem() {
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

    return Dialog.fullscreen(
      child: Scaffold(
        appBar: FAppBar(
          title: widget.recipe.label,
          scrollController: null,
          actions: [
            IconButton.filledTonal(
              onPressed: _enableDecreaseFont ? decreaseFont : null,
              icon: const Icon(MdiIcons.formatFontSizeDecrease),
            ),
            const SizedBox(width: PADDING),
            IconButton.filledTonal(
              onPressed: increaseFont,
              icon: const Icon(MdiIcons.formatFontSizeIncrease),
            ),
          ],
        ),
        body: SafeArea(
          child: FFixedResponsive(
            maxWidth: FBreakpoint.lgValue,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final fullHeight = constraints.maxHeight;

                final heightBottomPadding =
                    fullHeight -
                    PADDING -
                    const SlidingPanelHandle().preferredSize.height;

                // 40 = button height
                final contentHeight = heightBottomPadding - PADDING - 40;

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

                return Stack(
                  fit: .expand,
                  children: [
                    Align(
                      alignment: .topCenter,
                      child: SizedBox(
                        height: heightBottomPadding,
                        child: Center(
                          child: Column(
                            spacing: PADDING,
                            mainAxisSize: .min,
                            children: [
                              FGuideCardCarousel(
                                currentKey: currentStep.key,
                                slideDirection: _slideDirection,
                                height: cardHeight,
                                child: currentStep,
                              ),
                              SizedBox(
                                height: 40,
                                child: Row(
                                  spacing: PADDING,
                                  mainAxisAlignment: .center,
                                  children: [
                                    if (index > 0)
                                      FButton(
                                        width: 150,
                                        leading: const Icon(
                                          MdiIcons.chevronLeft,
                                        ),
                                        label: context.l10n.btn_back,
                                        onPressed: previousItem,
                                      ),
                                    if (index < steps.length - 1)
                                      FButton(
                                        width: 150,
                                        trailing: const Icon(
                                          MdiIcons.chevronRight,
                                        ),
                                        label: context.l10n.btn_next,
                                        onPressed: nextItem,
                                      )
                                    else
                                      FButton(
                                        width: 150,
                                        leading: const Icon(MdiIcons.close),
                                        label: context.l10n.btn_close,
                                        onPressed: () => context.pop(),
                                      ),
                                  ],
                                ),
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
                                  ingredientGroups:
                                      widget.recipe.ingredientGroups,
                                  decreaseServing: null,
                                  increaseServing: null,
                                  amountFactor: widget.amountFactor,
                                  newAmount:
                                      widget.amountFactor *
                                      widget.recipe.serving.amount,
                                  servingLabel: widget.recipe.serving.label,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
