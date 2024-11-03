import 'package:drift/drift.dart';
import 'package:flavormate/drift/app_database.dart';
import 'package:flavormate/models/story_draft/story_draft.dart';
import 'package:flavormate/riverpod/drift/p_drift.dart';
import 'package:flavormate/riverpod/stories/p_story.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'p_story_drafts.g.dart';

@riverpod
class PStoryDrafts extends _$PStoryDrafts {
  @override
  Future<List<StoryDraft>> build() async {
    final response =
        await (ref.watch(pDriftProvider).storyDraftTable.select()).get();

    return response.map((data) => StoryDraft.fromDB(data)).toList();
  }

  Future<int> createDraft() async {
    final response = await ref
        .read(pDriftProvider)
        .storyDraftTable
        .insert()
        .insert(StoryDraftTableCompanion());

    ref.invalidateSelf();
    return response;
  }

  Future<bool> deleteDraft(int id) async {
    await ref
        .read(pDriftProvider)
        .storyDraftTable
        .deleteWhere((draft) => draft.id.isValue(id));

    ref.invalidateSelf();
    return true;
  }

  Future<int?> storyToDraft(String id) async {
    final exists = await (ref.read(pDriftProvider).storyDraftTable.select()
          ..where((d) => d.id.isValue(int.parse(id))))
        .getSingleOrNull();

    if (exists != null) return null;

    final story = await ref.read(pStoryProvider(int.parse(id)).future);

    final response =
        await ref.read(pDriftProvider).storyDraftTable.insert().insert(
              StoryDraftTableCompanion(
                id: Value(story.id!),
                content: Value(story.content),
                label: Value(story.label),
                recipe: Value(story.recipe),
                version: Value(story.version!),
              ),
            );

    ref.invalidateSelf();
    return response;
  }
}
