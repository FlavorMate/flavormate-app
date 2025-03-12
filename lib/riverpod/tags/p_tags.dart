import 'package:flavormate/models/pageable/pageable.dart';
import 'package:flavormate/models/tag/tag.dart';
import 'package:flavormate/riverpod/api/p_api.dart';
import 'package:flavormate/riverpod/tags/p_tags_page.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'p_tags.g.dart';

@riverpod
class PTags extends _$PTags {
  @override
  Future<Pageable<Tag>> build() async {
    final page = ref.watch(pTagsPageProvider);
    return await ref
        .watch(pApiProvider)
        .tagsClient
        .findByPage(page: page, sortBy: 'label', sortDirection: 'ASC');
  }
}
