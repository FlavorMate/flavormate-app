import 'package:flavormate/models/pageable/pageable.dart';
import 'package:flavormate/models/recipe/recipe.dart';
import 'package:flavormate/riverpod/api/p_api.dart';
import 'package:flavormate/riverpod/recipes/p_recipes_page.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'p_recipes.g.dart';

@riverpod
class PRecipes extends _$PRecipes {
  @override
  Future<Pageable<Recipe>> build() async {
    final page = ref.watch(pRecipesPageProvider);
    return await ref.watch(pApiProvider).recipesClient.findByPage(
          page: page,
          sortBy: 'label',
          sortDirection: 'ASC',
        );
  }
}
