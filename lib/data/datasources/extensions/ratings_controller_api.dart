import 'dart:convert';

import 'package:flavormate/core/constants/api_constants.dart';
import 'package:flavormate/data/datasources/controller_api.dart';
import 'package:flavormate/data/models/extensions/ratings/recipe_rating_dto.dart';
import 'package:flavormate/data/models/shared/models/api_response.dart';
import 'package:flutter/foundation.dart';

@immutable
class RatingsControllerApi extends ControllerApi {
  static const _root = ApiConstants.ExtensionRatings;

  const RatingsControllerApi(super.dio);

  Future<RecipeRatingDto?> getRecipesIdRating({required String id}) async {
    final response = await get(
      url: '$_root/$id',
      mapper: (val) {
        if (val == null || val is! Map<String, dynamic>) return null;

        return RecipeRatingDtoMapper.fromMap(val);
      },
    );

    return response.data;
  }

  Future<ApiResponse<void>> putRecipesIdRating({
    required String id,
    required double rating,
  }) async {
    return await put(
      url: '$_root/$id',
      data: jsonEncode({'rating': rating}),
      mapper: ControllerApi.nullMapper,
    );
  }

  Future<ApiResponse<void>> deleteRecipesIdRating({
    required String id,
  }) async {
    return await delete(
      url: '$_root/$id',
      mapper: ControllerApi.nullMapper,
    );
  }
}
