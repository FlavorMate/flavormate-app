import 'package:flavormate/core/apis/rest/p_dio_private.dart';
import 'package:flavormate/data/datasources/features/story_controller_api.dart';
import 'package:flavormate/data/models/shared/models/api_response.dart';
import 'package:flavormate/data/repositories/features/accounts/p_rest_accounts_self.dart';
import 'package:flavormate/data/repositories/features/stories/p_rest_stories.dart';
import 'package:flavormate/data/repositories/features/stories/p_rest_stories_id.dart';
import 'package:flavormate/data/repositories/features/story_drafts/p_rest_story_drafts.dart';
import 'package:flavormate/presentation/features/stories_item/models/story_page_wrapper.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'p_stories_item_page.g.dart';

@riverpod
class PStoriesItemPage extends _$PStoriesItemPage {
  @override
  Future<StoriesItemWrapper> build({required String storyId}) async {
    final story = await ref.watch(pRestStoriesIdProvider(storyId).future);
    final self = await ref.watch(pRestAccountsSelfProvider.future);

    return StoriesItemWrapper(
      story: story,
      isAdmin: self.isAdmin,
      isOwner: self.id == story.ownedBy.id,
    );
  }

  Future<ApiResponse<void>> deleteStory() async {
    final dio = ref.read(pDioPrivateProvider);

    final client = StoryControllerApi(dio);

    final response = await client.deleteStoriesId(id: storyId);

    ref.invalidate(pRestStoriesProvider);

    return response;
  }

  Future<ApiResponse<String>> editStory() async {
    final dio = ref.read(pDioPrivateProvider);

    final client = StoryControllerApi(dio);

    final response = await client.postStoriesId(id: storyId);

    ref.invalidate(pRestStoryDraftsProvider);

    return response;
  }
}
