import 'package:flavormate/interfaces/a_search_client.dart';
import 'package:flavormate/models/author/author.dart';
import 'package:flavormate/models/pageable/pageable.dart';
import 'package:flavormate/models/recipe/recipe.dart';

class AuthorsClient extends ASearchClient<Author> {
  AuthorsClient({
    required super.httpClient,
    required super.baseURL,
    required super.parser,
  });

  Future<Pageable<Recipe>> findRecipesInAuthor(int id,
      {required int page}) async {
    final params = getParams({
      'size': 6,
      'sortBy': 'label',
      'sortDirection': 'ASC',
      'page': page,
    });

    final response = await httpClient.get('$baseURL/$id/recipes?$params');

    return Pageable.fromMap(response.data!, RecipeMapper.fromMap);
  }
}
