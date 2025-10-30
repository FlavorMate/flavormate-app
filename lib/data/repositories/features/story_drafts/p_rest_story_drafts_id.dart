import 'package:flavormate/core/apis/rest/p_dio_private.dart';
import 'package:flavormate/core/extensions/e_string.dart';
import 'package:flavormate/data/datasources/features/story_draft_controller_api.dart';
import 'package:flavormate/data/models/features/story_drafts/story_draft_dto.dart';
import 'package:flavormate/data/models/shared/models/api_response.dart';
import 'package:flavormate/data/repositories/features/stories/p_rest_stories.dart';
import 'package:flavormate/data/repositories/features/story_drafts/p_rest_story_drafts.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'p_rest_story_drafts_id.g.dart';

@riverpod
class PRestStoryDraftsId extends _$PRestStoryDraftsId {
  @override
  Future<StoryDraftFullDto> build({required String storyDraftId}) async {
    final dio = ref.watch(pDioPrivateProvider);

    final client = StoryDraftControllerApi(dio);

    final response = await client.getStoryDraftsId(id: storyDraftId);

    return response;
  }

  Future<void> delete() async {
    final dio = ref.read(pDioPrivateProvider);

    final client = StoryDraftControllerApi(dio);

    await client.deleteStoryDraftsId(id: storyDraftId);
  }

  Future<ApiResponse<String>> upload() async {
    final dio = ref.read(pDioPrivateProvider);

    final client = StoryDraftControllerApi(dio);

    final response = await client.postStoryDraftsId(id: storyDraftId);

    ref.invalidate(pRestStoriesProvider);
    ref.invalidate(pRestStoryDraftsProvider);

    return response;
  }

  Future<void> setLabel(String label) async {
    await setForm({'label': label.trimToNull});
  }

  Future<void> setContent(String content) async {
    await setForm({'content': content.trimToNull});
  }

  Future<void> setRecipe(String recipe) async {
    await setForm({'recipe': recipe.trimToNull});
  }

  Future<void> setForm(Map<String, dynamic> form) async {
    final dio = ref.read(pDioPrivateProvider);

    final client = StoryDraftControllerApi(dio);

    await client.putStoryDraftsId(
      id: storyDraftId,
      form: form,
    );

    ref.invalidateSelf();
    ref.invalidate(pRestStoryDraftsProvider);
  }
}
