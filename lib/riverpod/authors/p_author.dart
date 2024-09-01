import 'package:flavormate/models/pageable/pageable.dart';
import 'package:flavormate/models/recipe/recipe.dart';
import 'package:flavormate/riverpod/api/p_api.dart';
import 'package:flavormate/riverpod/authors/p_author_page.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'p_author.g.dart';

@riverpod
class PAuthor extends _$PAuthor {
  @override
  Future<Pageable<Recipe>> build(int id) async {
    final page = ref.watch(pAuthorPageProvider);
    return await ref
        .watch(pApiProvider)
        .authorsClient
        .findRecipesInAuthor(id, page: page);
  }
}
