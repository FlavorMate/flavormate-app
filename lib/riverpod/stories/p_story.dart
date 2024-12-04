import 'package:flavormate/models/story.dart';
import 'package:flavormate/riverpod/api/p_api.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'p_story.g.dart';

@riverpod
class PStory extends _$PStory {
  @override
  Future<Story> build(int id) async {
    return await ref.watch(pApiProvider).storiesClient.findById(id);
  }
}
