import 'package:flavormate/models/draft/draft.dart';
import 'package:flavormate/models/recipe/course.dart';
import 'package:flavormate/models/recipe/diet.dart';
import 'package:flavormate/models/recipe_draft/ingredients/ingredient_group_draft.dart';
import 'package:flavormate/models/recipe_draft/instructions/instruction_group_draft.dart';
import 'package:flavormate/models/recipe_draft/serving_draft/serving_draft.dart';
import 'package:flavormate/models/tag_draft/tag_draft.dart';
import 'package:flavormate/riverpod/api/p_api.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'p_draft.g.dart';

@riverpod
class PDraft extends _$PDraft {
  @override
  Future<Draft> build(String id) async {
    return Draft.empty();
  }

  void setCommon(Map<String, String?> data) {
    state.value!.recipeDraft.label = data['label'];
    state.value!.recipeDraft.description = data['description'];
    ref.notifyListeners();
  }

  void setServing(ServingDraft response) {
    state.value!.recipeDraft.serving = response;
    ref.notifyListeners();
  }

  void setDurations(Map<String, Duration> data) {
    state.value!.recipeDraft.prepTime = data['prepTime']!;
    state.value!.recipeDraft.cookTime = data['cookTime']!;
    state.value!.recipeDraft.restTime = data['restTime']!;
    ref.notifyListeners();
  }

  void setIngredientGroups(List<IngredientGroupDraft> response) {
    state.value!.recipeDraft.ingredientGroups = response;
    ref.notifyListeners();
  }

  void setInstructionGroups(List<InstructionGroupDraft> response) {
    state.value!.recipeDraft.instructionGroups = response;
    ref.notifyListeners();
  }

  void setCourse(Course response) {
    state.value!.recipeDraft.course = response;
    ref.notifyListeners();
  }

  void setDiet(Diet response) {
    state.value!.recipeDraft.diet = response;
    ref.notifyListeners();
  }

  void setTags(List<TagDraft> response) {
    state.value!.recipeDraft.tags = response;
    ref.notifyListeners();
  }

  void setCategories(List<int> response) {
    state.value!.recipeDraft.categories = response;
    ref.notifyListeners();
  }

  void set(Draft response) {
    state = AsyncData(response);
    ref.notifyListeners();
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

      return true;
    } catch (_) {
      return false;
    }
  }
}
