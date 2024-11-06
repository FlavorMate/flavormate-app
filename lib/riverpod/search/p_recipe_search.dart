import 'package:flavormate/models/recipe/recipe.dart';
import 'package:flavormate/riverpod/api/p_api.dart';
import 'package:flavormate/riverpod/search/p_recipe_search_term.dart';
import 'package:flavormate/riverpod/user/p_user.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'p_recipe_search.g.dart';

@riverpod
class PRecipeSearch extends _$PRecipeSearch {
  @override
  Future<List<Recipe>> build() async {
    final term = ref.watch(pRecipeSearchTermProvider);
    if (term.length < 3) return [];
    // We capture whether the provider is currently disposed or not.
    var didDispose = false;
    ref.onDispose(() => didDispose = true);

    // We delay the request by 1000ms, to wait for the user to stop refreshing.
    await Future<void>.delayed(const Duration(milliseconds: 1000));

    // If the provider was disposed during the delay, it means that the user
    // refreshed again. We throw an exception to cancel the request.
    // It is safe to use an exception here, as it will be caught by Riverpod.
    if (didDispose) {
      throw Exception('Cancelled');
    }

    final user = await ref.read(pUserProvider.selectAsync((data) => data));

    final response = await ref.read(pApiProvider).recipesClient.findBySearch(
          searchTerm: term,
          filter: user.diet!,
          sortBy: 'label',
        );

    final recipeResponses = response.content.toList();

    recipeResponses.sort((a, b) => a.label.length - b.label.length);
    return recipeResponses;
  }
}
