import 'package:flavormate/models/recipe/recipe.dart';
import 'package:flavormate/riverpod/api/p_api.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'p_recipe.g.dart';

@riverpod
class PRecipe extends _$PRecipe {
  @override
  Future<Recipe> build(int id) async {
    return await ref.watch(pApiProvider).recipesClient.findById(id);
  }
}
