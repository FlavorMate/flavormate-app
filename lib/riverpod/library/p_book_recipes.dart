import 'package:flavormate/models/pageable/pageable.dart';
import 'package:flavormate/models/recipe/recipe.dart';
import 'package:flavormate/riverpod/api/p_api.dart';
import 'package:flavormate/riverpod/library/p_book_page.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'p_book_recipes.g.dart';

@riverpod
class PBookRecipes extends _$PBookRecipes {
  @override
  Future<Pageable<Recipe>> build(int id) async {
    final page = ref.watch(pBookPageProvider);
    return await ref
        .watch(pApiProvider)
        .libraryClient
        .findRecipesInBook(id, page: page);
  }
}
