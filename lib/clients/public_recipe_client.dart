import 'package:flavormate/interfaces/a_base_client.dart';
import 'package:flavormate/models/recipe/recipe.dart';

class PublicRecipeClient extends ABaseClient<Recipe> {
  PublicRecipeClient({
    required super.httpClient,
    required super.baseURL,
    required super.parser,
  });

  Future<Recipe> findByIdL10n(
    String token,
    int id,
    String language,
  ) async {
    final params = getParams({'token': token, 'language': language});
    final response = await httpClient.get('$baseURL/$id/l10n?$params');
    return parser(response.data);
  }
}
