import 'package:flavormate/models/pageable/pageable.dart';
import 'package:flavormate/models/recipe/recipe.dart';
import 'package:flavormate/riverpod/api/p_api.dart';
import 'package:flavormate/riverpod/tags/p_tag_page.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'p_tag.g.dart';

@riverpod
class PTag extends _$PTag {
  @override
  Future<Pageable<Recipe>> build(int id) async {
    final page = ref.watch(pTagPageProvider);
    return await ref
        .watch(pApiProvider)
        .tagsClient
        .findAllRecipesInTag(id, page);
  }
}
