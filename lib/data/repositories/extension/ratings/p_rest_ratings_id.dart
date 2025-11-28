import 'package:flavormate/core/apis/rest/p_dio_private.dart';
import 'package:flavormate/data/datasources/extensions/ratings_controller_api.dart';
import 'package:flavormate/data/models/extensions/ratings/recipe_rating_dto.dart';
import 'package:flavormate/data/models/shared/models/api_response.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'p_rest_ratings_id.g.dart';

@riverpod
class PRestRatingsId extends _$PRestRatingsId {
  @override
  Future<RecipeRatingDto?> build(String recipeId) async {
    final dio = ref.read(pDioPrivateProvider);

    final client = RatingsControllerApi(dio);

    final response = await client.getRecipesIdRating(id: recipeId);

    return response;
  }

  Future<ApiResponse<void>> setRating(double? val) async {
    final dio = ref.read(pDioPrivateProvider);

    final client = RatingsControllerApi(dio);

    ApiResponse<void> response;

    if (val == null) {
      response = await client.deleteRecipesIdRating(
        id: recipeId,
      );
    } else {
      response = await client.putRecipesIdRating(
        id: recipeId,
        rating: val,
      );
    }

    ref.invalidateSelf();

    return response;
  }

  Future<ApiResponse<void>> deleteRating() async {
    final dio = ref.read(pDioPrivateProvider);

    final client = RatingsControllerApi(dio);

    final response = await client.deleteRecipesIdRating(id: recipeId);

    ref.invalidateSelf();

    return response;
  }
}
