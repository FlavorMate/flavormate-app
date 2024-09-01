import 'package:flavormate/models/pageable/pageable.dart';
import 'package:flavormate/models/story.dart';
import 'package:flavormate/riverpod/api/p_api.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'p_stories.g.dart';

@riverpod
class PStories extends _$PStories {
  @override
  Future<Pageable<Story>> build() async {
    return await ref.watch(pApiProvider).storiesClient.findByPage(page: 0);
  }
}
