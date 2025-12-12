import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/core/constants/state_icon_constants.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/core/riverpod/timer/p_timer.dart';
import 'package:flavormate/core/riverpod/timer/timer_state.dart';
import 'package:flavormate/data/models/features/recipe_draft/recipe_draft_dto.dart';
import 'package:flavormate/data/models/shared/enums/course.dart';
import 'package:flavormate/data/models/shared/enums/diet.dart';
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
import 'package:flavormate/presentation/features/recipe_editor_item/widgets/recipe_editor_item_course_picker.dart';
import 'package:flavormate/presentation/features/recipe_editor_item/widgets/recipe_editor_item_diet_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RecipeEditorItemPage extends ConsumerWidget {
  final String id;

  const RecipeEditorItemPage({required this.id, super.key});

  PRestRecipeDraftsIdProvider get provider => pRestRecipeDraftsIdProvider(id);

  PTimerProvider get timerProvider =>
      pTimerProvider(TimerState.recipeEditor.getId(id));

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FProviderPage(
      provider: provider,
      appBarBuilder: (_, data) => FAppBar(
        title: data.label ?? context.l10n.recipe_editor_item_page__title,
        actions: [FSaveState(provider: timerProvider)],
      ),
      floatingActionButtonBuilder: (context, data) => FloatingActionButton(
        onPressed: () => openPreview(context, data),
        child: const Icon(MdiIcons.chevronRight),
      ),
      builder: (_, data) => SafeArea(
        child: FResponsive(
          child: Column(
            spacing: PADDING,
            children: [
              FTileGroup(
                items: [
                  FTile(
                    label: context.l10n.recipe_editor_item_page__common,
                    subLabel: context.l10n.recipe_editor_item_page__common_hint,

                    leading: const FTileIcon(icon: MdiIcons.noteEdit),
                    onTap: () => context.routes.recipeEditorItemCommon(id),
                    trailing: FProgressColor(
                      state: data.commonProgress,
                      color: context.colorScheme.primary,
                    ),
                  ),
                  FTile(
                    label: context.l10n.recipe_editor_item_page__media,
                    subLabel: context.l10n.recipe_editor_item_page__media_hint,

                    leading: const FTileIcon(icon: MdiIcons.imageMultiple),
                    onTap: () => context.routes.recipeEditorItemFiles(id),
                    trailing: FProgressColor(
                      state: data.imageProgress,
                      color: context.colorScheme.primary,
                      optional: true,
                    ),
                  ),
                  FTile(
                    label: context.l10n.recipe_editor_item_page__origin,
                    subLabel: context.l10n.recipe_editor_item_page__origin_hint,

                    leading: const FTileIcon(icon: MdiIcons.web),
                    onTap: () => context.routes.recipeEditorItemOrigin(id),
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
                      icon: MdiIcons.silverwareForkKnife,
                    ),
                    onTap: () => context.routes.recipeEditorItemServing(id),
                    trailing: FProgressColor(
                      state: data.servingProgress,
                      color: context.colorScheme.primary,
                    ),
                  ),
                  FTile(
                    label: context.l10n.recipe_editor_item_page__durations,
                    subLabel:
                        context.l10n.recipe_editor_item_page__durations_hint,

                    leading: const FTileIcon(icon: MdiIcons.clock),
                    onTap: () => context.routes.recipeEditorItemDurations(id),
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

                    leading: const FTileIcon(icon: MdiIcons.foodApple),
                    onTap: () =>
                        context.routes.recipeEditorItemIngredientGroups(id),
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

                    leading: const FTileIcon(icon: MdiIcons.formatListChecks),
                    onTap: () =>
                        context.routes.recipeEditorItemInstructionGroups(id),
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
                    subLabel: 'Vorspeise, Hauptspeise, Dessert, etc.',

                    leading: const FTileIcon(icon: MdiIcons.foodVariant),
                    onTap: () => editCourse(context, ref, data.course),
                    trailing: FProgressColor(
                      state: data.courseProgress,
                      color: context.colorScheme.primary,
                    ),
                  ),
                  FTile(
                    label: context.l10n.recipe_editor_item_page__diet,
                    subLabel: context.l10n.recipe_editor_item_page__diet_hint,

                    leading: const FTileIcon(icon: MdiIcons.leaf),
                    onTap: () => editDiet(context, ref, data.diet),
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

                    leading: const FTileIcon(icon: MdiIcons.tagMultiple),
                    onTap: () => context.routes.recipeEditorItemTags(id),
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

                    leading: const FTileIcon(icon: MdiIcons.package),
                    onTap: () => context.routes.recipeEditorItemCategories(id),
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
        icon: StateIconConstants.drafts.errorIcon,
      ),
    );
  }

  Future<void> editCourse(
    BuildContext context,
    WidgetRef ref,
    Course? course,
  ) async {
    final response = await showDialog<Course>(
      context: context,
      builder: (_) => RecipeEditorItemCoursePicker(course: course),
    );

    if (!context.mounted || response == null) return;

    await ref.read(provider.notifier).setCourse(response);
  }

  Future<void> editDiet(BuildContext context, WidgetRef ref, Diet? diet) async {
    final response = await showDialog<Diet>(
      context: context,
      builder: (_) => RecipeEditorItemDietPicker(diet: diet),
    );

    if (!context.mounted || response == null) return;

    await ref.read(provider.notifier).setDiet(response);
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
    return context.routes.recipeEditorItemPreview(id);
  }
}
