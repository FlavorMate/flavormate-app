import 'package:flavormate/components/editor/dialogs/d_categories.dart';
import 'package:flavormate/components/editor/dialogs/d_common.dart';
import 'package:flavormate/components/editor/dialogs/d_course.dart';
import 'package:flavormate/components/editor/dialogs/d_diet.dart';
import 'package:flavormate/components/editor/dialogs/d_durations.dart';
import 'package:flavormate/components/editor/dialogs/d_images.dart';
import 'package:flavormate/components/editor/dialogs/d_ingredient_groups.dart';
import 'package:flavormate/components/editor/dialogs/d_instruction_groups.dart';
import 'package:flavormate/components/editor/dialogs/d_preview.dart';
import 'package:flavormate/components/editor/dialogs/d_serving.dart';
import 'package:flavormate/components/editor/dialogs/d_tags.dart';
import 'package:flavormate/components/editor/t_progress.dart';
import 'package:flavormate/components/riverpod/r_struct.dart';
import 'package:flavormate/components/t_app_bar.dart';
import 'package:flavormate/components/t_button.dart';
import 'package:flavormate/components/t_column.dart';
import 'package:flavormate/components/t_responsive.dart';
import 'package:flavormate/l10n/generated/l10n.dart';
import 'package:flavormate/models/draft/draft.dart';
import 'package:flavormate/models/recipe/course.dart';
import 'package:flavormate/models/recipe/diet.dart';
import 'package:flavormate/models/recipe_draft/ingredients/ingredient_group_draft.dart';
import 'package:flavormate/models/recipe_draft/recipe_draft.dart';
import 'package:flavormate/models/recipe_draft/serving_draft/serving_draft.dart';
import 'package:flavormate/models/tag_draft/tag_draft.dart';
import 'package:flavormate/riverpod/draft/p_draft.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class EditorPage extends ConsumerWidget {
  final String id;

  const EditorPage({required this.id, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(pDraftProvider(id));
    return Scaffold(
      appBar: const TAppBar(title: 'Editor'),
      body: RStruct(
        provider,
        (_, draft) => TResponsive(
          child: TColumn(
            children: [
              TButton(
                onPressed: () => editCommon(
                  context,
                  ref,
                  draft.recipeDraft,
                ),
                leading: const Icon(MdiIcons.pen),
                label: L10n.of(context).d_editor_common_title,
                trailing: TProgress(
                  completed: draft.recipeDraft.commonProgress,
                ),
              ),
              TButton(
                onPressed: () => editServing(
                  context,
                  ref,
                  draft.recipeDraft,
                ),
                leading: const Icon(MdiIcons.pen),
                label: L10n.of(context).d_editor_serving_title,
                trailing: TProgress(
                  completed: draft.recipeDraft.servingProgress,
                ),
              ),
              TButton(
                onPressed: () => editDurations(
                  context,
                  ref,
                  draft.recipeDraft,
                ),
                leading: const Icon(MdiIcons.pen),
                label: L10n.of(context).d_editor_durations_title,
                trailing: TProgress(
                  completed: draft.recipeDraft.durationProgress,
                ),
              ),
              TButton(
                onPressed: () => editIngredientGroups(
                  context,
                  ref,
                  draft.recipeDraft,
                ),
                leading: const Icon(MdiIcons.pen),
                label: L10n.of(context).d_editor_ingredient_groups_title,
                trailing: TProgress(
                  completed: draft.recipeDraft.ingredientsProgress,
                ),
              ),
              TButton(
                onPressed: () => editInstructionGroups(
                  context,
                  ref,
                  draft.recipeDraft,
                ),
                leading: const Icon(MdiIcons.pen),
                label: L10n.of(context).d_editor_instruction_groups_title,
                trailing: TProgress(
                  completed: draft.recipeDraft.instructionsProgress,
                ),
              ),
              TButton(
                onPressed: () => editCourse(
                  context,
                  ref,
                  draft.recipeDraft,
                ),
                leading: const Icon(MdiIcons.pen),
                label: L10n.of(context).d_editor_course_title,
                trailing: TProgress(
                  completed: draft.recipeDraft.courseProgress,
                ),
              ),
              TButton(
                onPressed: () => editDiet(
                  context,
                  ref,
                  draft.recipeDraft,
                ),
                leading: const Icon(MdiIcons.pen),
                label: L10n.of(context).d_editor_diet_title,
                trailing: TProgress(
                  completed: draft.recipeDraft.dietProgress,
                ),
              ),
              TButton(
                onPressed: () => editTags(context, ref, draft.recipeDraft),
                leading: const Icon(MdiIcons.pen),
                label: L10n.of(context).d_editor_tags_title,
                trailing: TProgress(
                  completed: draft.recipeDraft.tagsProgress,
                  optional: true,
                ),
              ),
              TButton(
                onPressed: () => editCategories(
                  context,
                  ref,
                  draft.recipeDraft,
                ),
                leading: const Icon(MdiIcons.pen),
                label: L10n.of(context).d_editor_categories_title,
                trailing: TProgress(
                  completed: draft.recipeDraft.categoriesProgress,
                  optional: true,
                ),
              ),
              TButton(
                onPressed: () => editImages(
                  context,
                  ref,
                  draft,
                ),
                leading: const Icon(MdiIcons.pen),
                label: L10n.of(context).d_editor_images_title,
                trailing: TProgress(
                  completed: draft.imagesProgress,
                  optional: true,
                ),
              ),
              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
      floatingActionButton: RStruct(
        provider,
        (_, draft) => FloatingActionButton(
          onPressed: draft.isValid
              ? () => showPreview(
                    context,
                    ref,
                    draft,
                  )
              : null,
          disabledElevation: 0,
          child: Icon(
            MdiIcons.contentSave,
            color: Theme.of(context).colorScheme.onPrimaryContainer,
          ),
        ),
      ),
    );
  }

  editCommon(
      BuildContext context, WidgetRef ref, RecipeDraft recipeDraft) async {
    final response = await showDialog<Map<String, String?>>(
      context: context,
      builder: (_) => DCommon(
        label: recipeDraft.label,
        description: recipeDraft.description,
      ),
      useSafeArea: false,
    );

    if (response == null) return;

    ref.read(pDraftProvider(id).notifier).setCommon(response);
  }

  editServing(
      BuildContext context, WidgetRef ref, RecipeDraft recipeDraft) async {
    final response = await showDialog<ServingDraft>(
      context: context,
      builder: (_) => DServing(serving: recipeDraft.serving),
      useSafeArea: false,
    );

    if (response == null) return;
    ref.read(pDraftProvider(id).notifier).setServing(response);
  }

  editDurations(
      BuildContext context, WidgetRef ref, RecipeDraft recipeDraft) async {
    final response = await showDialog<Map<String, Duration>>(
      context: context,
      builder: (_) => DDurations(
        prepTime: recipeDraft.prepTime,
        cookTime: recipeDraft.cookTime,
        restTime: recipeDraft.restTime,
      ),
      useSafeArea: false,
    );

    if (response == null) return;
    ref.read(pDraftProvider(id).notifier).setDurations(response);
  }

  editIngredientGroups(
      BuildContext context, WidgetRef ref, RecipeDraft recipeDraft) async {
    final response = await showDialog<List<IngredientGroupDraft>>(
      context: context,
      builder: (_) => DIngredientGroups(
        ingredientGroups: recipeDraft.ingredientGroups,
      ),
      useSafeArea: false,
    );

    if (response == null) return;
    ref.read(pDraftProvider(id).notifier).setIngredientGroups(response);
  }

  editInstructionGroups(
      BuildContext context, WidgetRef ref, RecipeDraft recipeDraft) async {
    final response = await showDialog(
      context: context,
      builder: (_) =>
          DInstructionGroups(instructionGroups: recipeDraft.instructionGroups),
      useSafeArea: false,
    );

    if (response == null) return;
    ref.read(pDraftProvider(id).notifier).setInstructionGroups(response);
  }

  editCourse(
      BuildContext context, WidgetRef ref, RecipeDraft recipeDraft) async {
    final response = await showDialog<Course>(
      context: context,
      builder: (_) => DCourse(course: recipeDraft.course),
    );

    if (response == null || response == recipeDraft.course) return;
    ref.read(pDraftProvider(id).notifier).setCourse(response);
  }

  editDiet(BuildContext context, WidgetRef ref, RecipeDraft recipeDraft) async {
    final response = await showDialog<Diet>(
      context: context,
      builder: (_) => DDiet(diet: recipeDraft.diet),
    );

    if (response == null || response == recipeDraft.diet) return;
    ref.read(pDraftProvider(id).notifier).setDiet(response);
  }

  editTags(BuildContext context, WidgetRef ref, RecipeDraft recipeDraft) async {
    final response = await showDialog<List<TagDraft>>(
      context: context,
      builder: (_) => DTags(tags: recipeDraft.tags),
      useSafeArea: false,
    );

    if (response == null) return;
    ref.read(pDraftProvider(id).notifier).setTags(response);
  }

  editCategories(
      BuildContext context, WidgetRef ref, RecipeDraft recipeDraft) async {
    final response = await showDialog<List<int>>(
      context: context,
      builder: (_) => DCategories(categories: recipeDraft.categories),
      useSafeArea: false,
    );

    if (response == null) return;
    ref.read(pDraftProvider(id).notifier).setCategories(response);
  }

  editImages(BuildContext context, WidgetRef ref, Draft draft) async {
    final response = await showDialog<Draft>(
      context: context,
      builder: (_) => DImages(draft: draft),
      useSafeArea: false,
    );

    if (response == null) return;
    ref.read(pDraftProvider(id).notifier).set(response);
  }

  showPreview(BuildContext context, WidgetRef ref, Draft draft) async {
    final response = await showDialog<bool>(
      context: context,
      builder: (_) => DPreview(draft: draft),
      useSafeArea: false,
    );

    if (response != true) return;

    if (await ref.read(pDraftProvider(id).notifier).upload()) {
      context.goNamed('home');
    }
  }
}
