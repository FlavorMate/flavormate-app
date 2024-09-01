import 'package:flavormate/interfaces/a_filter_search_client.dart';
import 'package:flavormate/models/recipe/course.dart';
import 'package:flavormate/models/recipe/diet.dart';
import 'package:flavormate/models/recipe/recipe.dart';

class RecipesClient extends AFilterSearchClient<Recipe> {
  RecipesClient({
    required super.httpClient,
    required super.baseURL,
    required super.parser,
  });

  Future<List<Recipe>> findRandom({
    required Diet diet,
    Course? course,
    int amount = 1,
  }) async {
    final params = getParams({'course': course?.name, 'amount': amount});
    final response = await httpClient.get<List<dynamic>>(
      '$baseURL/random/${diet.name}?$params',
    );

    return response.data!.map((recipe) => parser(recipe)).toList();
  }

  Future<bool> changeOwner(int recipeId, Map form) async {
    final response = await httpClient.put<bool>(
      '$baseURL/$recipeId/changeOwner',
      data: form,
    );

    return response.data ?? false;
  }

  String bring(String server, int id, int baseServing, int requestedServing) {
    final api = '$server$baseURL/$id/bring/$requestedServing';

    return 'https://api.getbring.com/rest/bringrecipes/deeplink?url=$api&source=web&baseQuantity=$baseServing&requestedQuantity=$requestedServing';
  }
}
