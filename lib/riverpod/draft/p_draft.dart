import 'package:drift/drift.dart';
import 'package:flavormate/drift/app_database.dart';
import 'package:flavormate/models/draft/draft.dart';
import 'package:flavormate/models/recipe/course.dart';
import 'package:flavormate/models/recipe/diet.dart';
import 'package:flavormate/models/recipe_draft/ingredients/ingredient_group_draft.dart';
import 'package:flavormate/models/recipe_draft/instructions/instruction_group_draft.dart';
import 'package:flavormate/models/recipe_draft/serving_draft/serving_draft.dart';
import 'package:flavormate/models/tag_draft/tag_draft.dart';
import 'package:flavormate/riverpod/api/p_api.dart';
import 'package:flavormate/riverpod/draft/p_drafts.dart';
import 'package:flavormate/riverpod/drift/p_drift.dart';
import 'package:flavormate/riverpod/highlights/p_highlight.dart';
import 'package:flavormate/riverpod/recipes/p_latest_recipes.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'p_draft.g.dart';

@riverpod
class PDraft extends _$PDraft {
  @override
  Future<Draft> build(String id) async {
    final response = await (ref.watch(pDriftProvider).draftTable.select()
          ..where((draft) => draft.id.isValue(int.parse(id))))
        .getSingle();

    return Draft.fromDB(response);
  }

  Future<bool> autosave() async {
    return await (ref.read(pDriftProvider).draftTable.update()).replace(
      DraftTableCompanion.insert(
        id: Value(state.value!.id),
        recipeDraft: state.value!.recipeDraft,
        images: state.value!.images,
        addedImages: state.value!.addedImages,
        removedImages: state.value!.removedImages,
        version: state.value!.version,
      ),
    );
  }

  void setCommon(Map<String, String?> data) {
    state.value!.recipeDraft.label = data['label'];
    state.value!.recipeDraft.description = data['description'];
    ref.notifyListeners();
    autosave();
  }

  void setServing(ServingDraft response) {
    state.value!.recipeDraft.serving = response;
    ref.notifyListeners();
    autosave();
  }

  void setDurations(Map<String, Duration> data) {
    state.value!.recipeDraft.prepTime = data['prepTime']!;
    state.value!.recipeDraft.cookTime = data['cookTime']!;
    state.value!.recipeDraft.restTime = data['restTime']!;
    ref.notifyListeners();
    autosave();
  }

  void setIngredientGroups(List<IngredientGroupDraft> response) {
    state.value!.recipeDraft.ingredientGroups = response;
    ref.notifyListeners();
    autosave();
  }

  void setInstructionGroups(List<InstructionGroupDraft> response) {
    state.value!.recipeDraft.instructionGroups = response;
    ref.notifyListeners();
    autosave();
  }

  void setCourse(Course response) {
    state.value!.recipeDraft.course = response;
    ref.notifyListeners();
    autosave();
  }

  void setDiet(Diet response) {
    state.value!.recipeDraft.diet = response;
    ref.notifyListeners();
    autosave();
  }

  void setTags(List<TagDraft> response) {
    state.value!.recipeDraft.tags = response;
    ref.notifyListeners();
    autosave();
  }

  void setCategories(List<int> response) {
    state.value!.recipeDraft.categories = response;
    ref.notifyListeners();
    autosave();
  }

  void set(Draft response) {
    state = AsyncData(response);
    ref.notifyListeners();
    autosave();
  }

  Future<bool> upload() async {
    try {
      final recipe = await ref
          .read(pApiProvider)
          .recipesClient
          .create(data: state.value!.recipeDraft.toMap());

      final files = <int>[];
      for (final image in state.value!.addedImages) {
        image.owner = recipe.id!;
        final file = await ref
            .read(pApiProvider)
            .filesClient
            .create(data: image.toMap());
        files.add(file.id!);
      }

      await ref
          .read(pApiProvider)
          .recipesClient
          .update(recipe.id!, data: {'files': files});

      await ref.read(pDraftsProvider.notifier).deleteDraft(state.value!.id);

      ref.invalidate(pHighlightProvider);
      ref.invalidate(pLatestRecipesProvider);

      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> edit() async {
    try {
      final draft = state.value!;
      final response = await ref.read(pApiProvider).recipesClient.update(
            draft.id,
            data: draft.recipeDraft.toMap(),
          );

      if (draft.addedImages.isEmpty && draft.removedImages.isEmpty) {
        return true;
      }

      final usedImages = draft.images
          .where((image) =>
              draft.removedImages
                  .indexWhere((rImage) => rImage.id == image.id) <
              0)
          .map((image) => image.id!);

      final images = [...usedImages];

      if (draft.addedImages.isNotEmpty) {
        final addedFiles =
            await Future.wait(draft.addedImages.map((addedImage) async {
          addedImage.owner = response.id!;
          return (await ref
                  .read(pApiProvider)
                  .filesClient
                  .create(data: addedImage.toMap()))
              .id!;
        }));
        images.addAll(addedFiles);
      }

      if (draft.removedImages.isNotEmpty) {
        var deletedFiles =
            await Future.wait(draft.removedImages.map((removedImage) async {
          final response = await ref
              .read(pApiProvider)
              .filesClient
              .deleteById(removedImage.id!);
          return response ? null : removedImage.id!;
        }));

        images.addAll(deletedFiles.nonNulls);
      }
      await ref
          .read(pApiProvider)
          .recipesClient
          .update(response.id!, data: {'files': images});

      await ref.read(pDraftsProvider.notifier).deleteDraft(state.value!.id);

      ref.invalidate(pHighlightProvider);
      ref.invalidate(pLatestRecipesProvider);

      return true;
    } catch (e) {
      return false;
    }
  }
}
