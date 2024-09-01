import 'package:flavormate/models/pageable/pageable.dart';
import 'package:flavormate/models/recipe/recipe.dart';
import 'package:flavormate/riverpod/api/p_api.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'p_latest_recipes.g.dart';

@riverpod
class PLatestRecipes extends _$PLatestRecipes {
  @override
  Future<Pageable<Recipe>> build() async {
    return await ref
        .watch(pApiProvider)
        .recipesClient
        .findByPage(page: 0, size: 10, sortBy: 'createdOn');
  }
}
