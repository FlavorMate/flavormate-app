import 'package:flavormate/models/pageable/pageable.dart';
import 'package:flavormate/models/recipe/recipe.dart';
import 'package:flavormate/riverpod/api/p_api.dart';
import 'package:flavormate/riverpod/categories/p_category_page.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'p_category.g.dart';

@riverpod
class PCategory extends _$PCategory {
  @override
  Future<Pageable<Recipe>> build(int id) async {
    final page = ref.watch(pCategoryPageProvider);
    final categories = await ref
        .watch(pApiProvider)
        .categoriesClient
        .findRecipesInCategory(id, page);

    return categories;
  }
}
