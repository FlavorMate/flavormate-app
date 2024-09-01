import 'package:flavormate/interfaces/a_search_client.dart';
import 'package:flavormate/models/library/book.dart';
import 'package:flavormate/models/pageable/pageable.dart';
import 'package:flavormate/models/recipe/recipe.dart';

class LibraryClient extends ASearchClient<Book> {
  LibraryClient({
    required super.httpClient,
    required super.baseURL,
    required super.parser,
  });

  Future<Book> toggleRecipeInBook(int bookId, int recipeId) async {
    final response = await httpClient.post('$baseURL/$bookId/toggle/$recipeId');
    return parser(response.data);
  }

  Future<Pageable<Recipe>> findRecipesInBook(int id,
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
