import 'package:drift/drift.dart';
import 'package:flavormate/drift/app_database.dart';
import 'package:flavormate/models/recipe/recipe.dart';
import 'package:flavormate/models/story_draft/story_draft.dart';
import 'package:flavormate/riverpod/api/p_api.dart';
import 'package:flavormate/riverpod/drift/p_drift.dart';
import 'package:flavormate/riverpod/stories/p_stories.dart';
import 'package:flavormate/riverpod/story_draft/p_story_drafts.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'p_story_draft.g.dart';

@riverpod
class PStoryDraft extends _$PStoryDraft {
  @override
  Future<StoryDraft> build(String id) async {
    final response = await (ref.watch(pDriftProvider).storyDraftTable.select()
          ..where((draft) => draft.id.isValue(int.parse(id))))
        .getSingle();

    return StoryDraft.fromDB(response);
  }

  Future<bool> autosave() async {
    final result =
        await (ref.read(pDriftProvider).storyDraftTable.update()).replace(
      StoryDraftTableCompanion.insert(
        id: Value(state.value!.id),
        label: Value(state.value!.label),
        content: Value(state.value!.content),
        recipe: Value(state.value!.recipe),
        version: Value(state.value!.version),
      ),
    );

    if (result) {
      ref.invalidate(pStoryDraftsProvider);
    }
    return result;
  }

  void setLabel(String? label) {
    state.value!.label = label;
    autosave();
  }

  void setContent(String? content) {
    state.value!.content = content;
    autosave();
  }

  void setRecipe(Recipe recipe) {
    state.value!.recipe = recipe;
    ref.notifyListeners();
    autosave();
  }

  Future<bool> upload() async {
    try {
      await ref
          .read(pApiProvider)
          .storiesClient
          .create(data: state.value!.toMap());

      await ref
          .read(pStoryDraftsProvider.notifier)
          .deleteDraft(state.value!.id);

      ref.invalidate(pStoriesProvider);

      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> edit() async {
    try {
      await ref.read(pApiProvider).recipesClient.update(
            state.value!.id,
            data: state.value!.toMap(),
          );

      await ref
          .read(pStoryDraftsProvider.notifier)
          .deleteDraft(state.value!.id);

      ref.invalidate(pStoriesProvider);

      return true;
    } catch (e) {
      return false;
    }
  }
}
