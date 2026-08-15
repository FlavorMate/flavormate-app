import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/core/constants/icon_constants.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/core/riverpod/timer/p_timer.dart';
import 'package:flavormate/core/riverpod/timer/timer_state.dart';
import 'package:flavormate/data/models/features/recipe_draft/recipe_draft_dto.dart';
import 'package:flavormate/data/repositories/features/recipe_drafts/p_rest_recipe_drafts_id.dart';
import 'package:flavormate/presentation/common/widgets/f_app_bar.dart';
import 'package:flavormate/presentation/common/widgets/f_empty_message.dart';
import 'package:flavormate/presentation/common/widgets/f_progress/f_progress_color.dart';
import 'package:flavormate/presentation/common/widgets/f_responsive.dart';
import 'package:flavormate/presentation/common/widgets/f_save_state.dart';
import 'package:flavormate/presentation/common/widgets/f_states/f_provider_page.dart';
import 'package:flavormate/presentation/common/widgets/f_tile_group/f_tile.dart';
import 'package:flavormate/presentation/common/widgets/f_tile_group/f_tile_group.dart';
import 'package:flavormate/presentation/common/widgets/f_tile_group/f_tile_icon.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_3_expressive/components/floating_action_buttons/m3e_floating_action_buttons.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:material_ui/material_ui.dart';

class RecipeEditorItemPage extends ConsumerStatefulWidget {
  final String id;

  const RecipeEditorItemPage({required this.id, super.key});

  PRestRecipeDraftsIdProvider get provider => pRestRecipeDraftsIdProvider(id);

  PTimerProvider get timerProvider =>
      pTimerProvider(TimerState.recipeEditor.getId(id));

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _RecipeEditorItemPageState();
}

class _RecipeEditorItemPageState extends ConsumerState<RecipeEditorItemPage> {
  final _controller = ScrollController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FProviderPage(
      provider: widget.provider,
      appBarBuilder: (_, data) => FAppBar(
        scrollController: _controller,
        title: data.label ?? context.l10n.recipe_editor_item_page__title,
        actions: [FSaveState(provider: widget.timerProvider)],
      ),
      floatingActionButtonBuilder: (context, data) => M3EFab(
        onPressed: () => openPreview(context, data),
        icon: const Icon(Symbols.chevron_right_rounded),
      ),
      builder: (_, data) => SafeArea(
        child: FResponsive(
          controller: _controller,
          child: Column(
            spacing: PADDING,
            children: [
              FTileGroup(
                items: [
                  FTile(
                    label: context.l10n.recipe_editor_item_page__common,
                    subLabel: context.l10n.recipe_editor_item_page__common_hint,

                    leading: const FTileIcon(
                      icon: Symbols.edit_document_rounded,
                    ),
                    onTap: () =>
                        context.routes.recipeEditorItemCommon(widget.id),
                    trailing: FProgressColor(
                      state: data.commonProgress,
                      color: context.colorScheme.primary,
                    ),
                  ),
                  FTile(
                    label: context.l10n.recipe_editor_item_page__media,
                    subLabel: context.l10n.recipe_editor_item_page__media_hint,

                    leading: const FTileIcon(
                      icon: Symbols.photo_library_rounded,
                    ),
                    onTap: () =>
                        context.routes.recipeEditorItemFiles(widget.id),
                    trailing: FProgressColor(
                      state: data.imageProgress,
                      color: context.colorScheme.primary,
                      optional: true,
                    ),
                  ),
                  FTile(
                    label: context.l10n.recipe_editor_item_page__origin,
                    subLabel: context.l10n.recipe_editor_item_page__origin_hint,

                    leading: const FTileIcon(icon: Symbols.language_rounded),
                    onTap: () =>
                        context.routes.recipeEditorItemOrigin(widget.id),
                    trailing: FProgressColor(
                      state: data.originProgress,
                      color: context.colorScheme.primary,
                      optional: true,
                    ),
                  ),
                ],
              ),
              FTileGroup(
                items: [
                  FTile(
                    label: context.l10n.recipe_editor_item_page__serving,
                    subLabel:
                        context.l10n.recipe_editor_item_page__serving_hint,

                    leading: const FTileIcon(
                      icon: Symbols.restaurant_rounded,
                    ),
                    onTap: () =>
                        context.routes.recipeEditorItemServing(widget.id),
                    trailing: FProgressColor(
                      state: data.servingProgress,
                      color: context.colorScheme.primary,
                    ),
                  ),
                  FTile(
                    label: context.l10n.recipe_editor_item_page__durations,
                    subLabel:
                        context.l10n.recipe_editor_item_page__durations_hint,

                    leading: const FTileIcon(
                      icon: Symbols.nest_clock_farsight_analog_rounded,
                    ),
                    onTap: () =>
                        context.routes.recipeEditorItemDurations(widget.id),
                    trailing: FProgressColor(
                      state: data.durationProgress,
                      color: context.colorScheme.primary,
                    ),
                  ),
                ],
              ),
              FTileGroup(
                items: [
                  FTile(
                    label:
                        context.l10n.recipe_editor_item_page__ingredient_groups,
                    subLabel: context
                        .l10n
                        .recipe_editor_item_page__ingredient_groups_hint,

                    leading: const FTileIcon(icon: Symbols.nutrition_rounded),
                    onTap: () => context.routes
                        .recipeEditorItemIngredientGroups(widget.id),
                    trailing: FProgressColor(
                      state: data.ingredientsProgress,
                      color: context.colorScheme.primary,
                    ),
                  ),
                  FTile(
                    label: context
                        .l10n
                        .recipe_editor_item_page__instruction_groups,
                    subLabel: context
                        .l10n
                        .recipe_editor_item_page__instruction_groups_hint,

                    leading: const FTileIcon(icon: Symbols.checklist_rounded),
                    onTap: () => context.routes
                        .recipeEditorItemInstructionGroups(widget.id),
                    trailing: FProgressColor(
                      state: data.instructionsProgress,
                      color: context.colorScheme.primary,
                    ),
                  ),
                ],
              ),

              FTileGroup(
                items: [
                  FTile(
                    label: context.l10n.recipe_editor_item_page__course,
                    subLabel: context.l10n.recipe_editor_item_page__course_hint,
                    leading: const FTileIcon(icon: Symbols.grocery_rounded),
                    onTap: () =>
                        context.routes.recipeEditorItemCourse(widget.id),
                    trailing: FProgressColor(
                      state: data.courseProgress,
                      color: context.colorScheme.primary,
                    ),
                  ),
                  FTile(
                    label: context.l10n.recipe_editor_item_page__diet,
                    subLabel: context.l10n.recipe_editor_item_page__diet_hint,

                    leading: const FTileIcon(icon: Symbols.eco_rounded),
                    onTap: () => context.routes.recipeEditorItemDiet(widget.id),
                    trailing: FProgressColor(
                      state: data.dietProgress,
                      color: context.colorScheme.primary,
                    ),
                  ),
                ],
              ),

              FTileGroup(
                items: [
                  FTile(
                    label: context.l10n.recipe_editor_item_page__tags,
                    subLabel: context.l10n.recipe_editor_item_page__tags_hint,

                    leading: const FTileIcon(icon: Symbols.sell_rounded),
                    onTap: () => context.routes.recipeEditorItemTags(widget.id),
                    trailing: FProgressColor(
                      state: data.tagsProgress,
                      color: context.colorScheme.primary,
                      optional: true,
                    ),
                  ),
                  FTile(
                    label: context.l10n.recipe_editor_item_page__categories,
                    subLabel:
                        context.l10n.recipe_editor_item_page__categories_hint,

                    leading: const FTileIcon(icon: Symbols.inventory_2_rounded),
                    onTap: () =>
                        context.routes.recipeEditorItemCategories(widget.id),
                    trailing: FProgressColor(
                      state: data.categoriesProgress,
                      color: context.colorScheme.primary,
                      optional: true,
                    ),
                  ),
                ],
              ),

              // Add spacer to prevent overlap with floating action button
              const SizedBox(height: 56),
            ],
          ),
        ),
      ),
      onError: FEmptyMessage(
        title: context.l10n.recipe_editor_item_page__on_error,
        icon: IconConstants.errorIcon,
      ),
    );
  }

  Future<void> openPreview(
    BuildContext context,
    RecipeDraftFullDto draft,
  ) async {
    if (!draft.isValid) {
      context.showTextSnackBar(
        context.l10n.recipe_editor_item_page__not_complete,
      );
      return;
    }
    return context.routes.recipeEditorItemPreview(widget.id);
  }
}
