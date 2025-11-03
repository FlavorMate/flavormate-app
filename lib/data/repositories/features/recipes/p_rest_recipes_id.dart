import 'package:flavormate/core/apis/rest/p_dio_private.dart';
import 'package:flavormate/core/utils/u_localizations.dart';
import 'package:flavormate/data/datasources/extensions/share_controller_api.dart';
import 'package:flavormate/data/datasources/features/recipe_controller_api.dart';
import 'package:flavormate/data/models/features/recipes/recipe_dto.dart';
import 'package:flavormate/data/models/shared/models/api_response.dart';
import 'package:flavormate/data/repositories/features/highlights/p_rest_highlights.dart';
import 'package:flavormate/data/repositories/features/recipes/p_rest_recipes.dart';
import 'package:flavormate/data/repositories/features/stories/p_rest_stories.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'p_rest_recipes_id.g.dart';

@riverpod
class PRestRecipesId extends _$PRestRecipesId {
  @override
  Future<RecipeFullDto> build(String recipeId) async {
    final language = currentLocalization().languageCode;

    final dio = ref.watch(pDioPrivateProvider);

    final client = RecipeControllerApi(dio);

    final response = await client.getRecipesId(
      id: recipeId,
      language: language,
    );

    return response;
  }

  Future<ApiResponse<void>> transferRecipe(
    String accountId,
    String newOwner,
  ) async {
    final dio = ref.read(pDioPrivateProvider);

    final client = RecipeControllerApi(dio);

    final response = await client.putRecipesIdTransfer(
      id: recipeId,
      newOwner: newOwner,
    );

    return response;
  }

  Future<ApiResponse<bool>> deleteRecipe() async {
    final dio = ref.read(pDioPrivateProvider);

    final client = RecipeControllerApi(dio);

    final response = await client.deleteRecipesId(id: recipeId);

    if (!response.hasError) {
      ref.invalidate(pRestRecipesProvider);
      ref.invalidate(pRestStoriesProvider);
      ref.invalidate(pRestHighlightsProvider);
    }

    return response;
  }

  Future<ApiResponse<String>> editRecipe() async {
    final dio = ref.read(pDioPrivateProvider);

    final client = RecipeControllerApi(dio);

    final response = await client.postRecipesId(
      id: recipeId,
    );

    return response;
  }

  Future<ApiResponse<String>> shareRecipe() async {
    final dio = ref.read(pDioPrivateProvider);

    final client = ShareControllerApi(dio);

    final response = await client.postCreateRecipeShare(
      id: recipeId,
    );

    return response;
  }
}
