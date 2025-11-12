import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/core/constants/state_icon_constants.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/core/riverpod/timer/p_timer.dart';
import 'package:flavormate/core/riverpod/timer/timer_state.dart';
import 'package:flavormate/data/models/features/recipe_draft/recipe_draft_dto.dart';
import 'package:flavormate/data/models/shared/enums/course.dart';
import 'package:flavormate/data/models/shared/enums/diet.dart';
import 'package:flavormate/data/repositories/features/recipe_drafts/p_rest_recipe_drafts_id.dart';
import 'package:flavormate/generated/l10n/l10n.dart';
import 'package:flavormate/presentation/common/widgets/f_app_bar.dart';
import 'package:flavormate/presentation/common/widgets/f_button.dart';
import 'package:flavormate/presentation/common/widgets/f_empty_message.dart';
import 'package:flavormate/presentation/common/widgets/f_progress/f_progress_color.dart';
import 'package:flavormate/presentation/common/widgets/f_responsive.dart';
import 'package:flavormate/presentation/common/widgets/f_save_state.dart';
import 'package:flavormate/presentation/common/widgets/f_states/f_provider_page.dart';
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
        title: data.label ?? L10n.of(context).recipe_editor_item_page__title,
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
              FButton(
                onPressed: () => context.routes.recipeEditorItemCommon(id),
                leading: const Icon(MdiIcons.noteEdit),
                label: L10n.of(context).recipe_editor_item_page__common,
                trailing: FProgressColor(
                  state: data.commonProgress,
                  color: context.colorScheme.onPrimary,
                ),
              ),
              FButton(
                onPressed: () => context.routes.recipeEditorItemServing(id),
                leading: const Icon(MdiIcons.silverwareForkKnife),
                label: L10n.of(context).recipe_editor_item_page__serving,
                trailing: FProgressColor(
                  state: data.servingProgress,
                  color: context.colorScheme.onPrimary,
                ),
              ),
              FButton(
                onPressed: () => context.routes.recipeEditorItemDurations(id),
                leading: const Icon(MdiIcons.clock),
                label: L10n.of(context).recipe_editor_item_page__durations,
                trailing: FProgressColor(
                  state: data.durationProgress,
                  color: context.colorScheme.onPrimary,
                ),
              ),
              FButton(
                onPressed: () =>
                    context.routes.recipeEditorItemIngredientGroups(id),
                leading: const Icon(MdiIcons.foodApple),
                label: L10n.of(
                  context,
                ).recipe_editor_item_page__ingredient_groups,
                trailing: FProgressColor(
                  state: data.ingredientsProgress,
                  color: context.colorScheme.onPrimary,
                ),
              ),
              FButton(
                onPressed: () =>
                    context.routes.recipeEditorItemInstructionGroups(id),
                leading: const Icon(MdiIcons.formatListChecks),
                label: L10n.of(
                  context,
                ).recipe_editor_item_page__instruction_groups,
                trailing: FProgressColor(
                  state: data.instructionsProgress,
                  color: context.colorScheme.onPrimary,
                ),
              ),
              FButton(
                onPressed: () => editCourse(context, ref, data.course),
                leading: const Icon(MdiIcons.foodVariant),
                label: L10n.of(context).recipe_editor_item_page__course,
                trailing: FProgressColor(
                  state: data.courseProgress,
                  color: context.colorScheme.onPrimary,
                ),
              ),
              FButton(
                onPressed: () => editDiet(context, ref, data.diet),
                leading: const Icon(MdiIcons.leaf),
                label: L10n.of(context).recipe_editor_item_page__diet,
                trailing: FProgressColor(
                  state: data.dietProgress,
                  color: context.colorScheme.onPrimary,
                ),
              ),
              FButton(
                onPressed: () => context.routes.recipeEditorItemTags(id),
                leading: const Icon(MdiIcons.tagMultiple),
                label: L10n.of(context).recipe_editor_item_page__tags,
                trailing: FProgressColor(
                  state: data.tagsProgress,
                  color: context.colorScheme.onPrimary,
                  optional: true,
                ),
              ),
              FButton(
                onPressed: () => context.routes.recipeEditorItemCategories(id),
                leading: const Icon(MdiIcons.viewGrid),
                label: L10n.of(context).recipe_editor_item_page__categories,
                trailing: FProgressColor(
                  state: data.categoriesProgress,
                  color: context.colorScheme.onPrimary,
                  optional: true,
                ),
              ),
              FButton(
                onPressed: () => context.routes.recipeEditorItemFiles(id),
                leading: const Icon(MdiIcons.imageMultiple),
                label: L10n.of(context).recipe_editor_item_page__media,
                trailing: FProgressColor(
                  state: data.imageProgress,
                  color: context.colorScheme.onPrimary,
                  optional: true,
                ),
              ),
              FButton(
                onPressed: () => context.routes.recipeEditorItemOrigin(id),
                leading: const Icon(MdiIcons.web),
                label: L10n.of(context).recipe_editor_item_page__origin,
                trailing: FProgressColor(
                  state: data.originProgress,
                  color: context.colorScheme.onPrimary,
                  optional: true,
                ),
              ),
            ],
          ),
        ),
      ),
      onError: FEmptyMessage(
        title: L10n.of(context).recipe_editor_item_page__on_error,
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
        L10n.of(context).recipe_editor_item_page__not_complete,
      );
      return;
    }
    return context.routes.recipeEditorItemPreview(id);
  }
}
