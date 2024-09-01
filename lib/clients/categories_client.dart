import 'package:flavormate/interfaces/a_search_l10n_client.dart';
import 'package:flavormate/models/categories/category.dart';
import 'package:flavormate/models/pageable/pageable.dart';
import 'package:flavormate/models/recipe/recipe.dart';

class CategoriesClient extends ASearchL10nClient<Category> {
  CategoriesClient({
    required super.httpClient,
    required super.baseURL,
    required super.parser,
  });

  Future<Pageable<Recipe>> findRecipesInCategory(int id, int page) async {
    final params = getParams({
      'size': 6,
      'sortBy': 'label',
      'sortDirection': 'ASC',
      'page': page,
    });

    final response = await httpClient.get('$baseURL/$id/recipes?$params');

    return Pageable.fromMap(response.data!, RecipeMapper.fromMap);
  }

  Future<Pageable<Category>> findNotEmpty({
    required String language,
    int? page,
    int? size,
    String? sortBy,
    String? sortDirection,
  }) async {
    final params = getParams({
      'language': language,
      'size': size,
      'sortBy': sortBy,
      'sortDirection': sortDirection,
      'page': page,
    });

    final response = await httpClient.get('$baseURL/notEmpty?$params');

    return Pageable.fromMap(response.data!, CategoryMapper.fromMap);
  }
}
