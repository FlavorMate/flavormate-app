import 'package:flavormate/core/apis/rest/p_dio_private.dart';
import 'package:flavormate/data/datasources/features/story_controller_api.dart';
import 'package:flavormate/data/models/features/stories/story_dto.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'p_rest_stories_id.g.dart';

@riverpod
class PRestStoriesId extends _$PRestStoriesId {
  @override
  Future<StoryFullDto> build(String storyId) async {
    final dio = ref.watch(pDioPrivateProvider);

    final client = StoryControllerApi(dio);

    final response = await client.getStoriesId(id: storyId);

    return response;
  }

  Future<void> delete() async {
    final dio = ref.read(pDioPrivateProvider);

    final client = StoryControllerApi(dio);

    await client.deleteStoriesId(id: storyId);
  }
}
