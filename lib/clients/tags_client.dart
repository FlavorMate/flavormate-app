import 'package:flavormate/interfaces/a_search_client.dart';
import 'package:flavormate/models/pageable/pageable.dart';
import 'package:flavormate/models/recipe/recipe.dart';
import 'package:flavormate/models/tag/tag.dart';

class TagsClient extends ASearchClient<Tag> {
  TagsClient({
    required super.httpClient,
    required super.baseURL,
    required super.parser,
  });

  Future<Pageable<Recipe>> findAllRecipesInTag(int id, int page) async {
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
