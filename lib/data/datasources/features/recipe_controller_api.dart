import 'dart:convert';

import 'package:flavormate/core/constants/api_constants.dart';
import 'package:flavormate/data/datasources/controller_api.dart';
import 'package:flavormate/data/models/features/recipes/recipe_dto.dart';
import 'package:flavormate/data/models/features/recipes/recipe_file_dto.dart';
import 'package:flavormate/data/models/local/pageable_dto.dart';
import 'package:flavormate/data/models/shared/enums/course.dart';
import 'package:flavormate/data/models/shared/enums/diet.dart';
import 'package:flavormate/data/models/shared/enums/order_by.dart';
import 'package:flavormate/data/models/shared/enums/order_direction.dart';
import 'package:flavormate/data/models/shared/models/api_response.dart';
import 'package:flutter/foundation.dart';

@immutable
class RecipeControllerApi extends ControllerApi {
  static const _root = ApiConstants.FeatureRecipes;

  const RecipeControllerApi(super.dio);

  Future<PageableDto<RecipePreviewDto>> getRecipes({
    int? page,
    int? pageSize,
    OrderBy? orderBy,
    OrderDirection? orderDirection,
  }) async {
    final response = await get(
      url: '$_root/',
      queryParameters: {
        'page': page,
        'pageSize': pageSize,
        'orderBy': orderBy?.name,
        'orderDirection': orderDirection?.name,
      },
      mapper: (data) => PageableDto.fromAPI<RecipePreviewDto>(
        data,
        RecipePreviewDto,
      ),
    );

    return response.data!;
  }

  Future<RecipeFullDto> getRecipesId({
    required String id,
    required String language,
  }) async {
    final response = await get(
      url: '$_root/$id',
      queryParameters: {
        'language': language,
      },
      mapper: (data) => RecipeFullDtoMapper.fromMap(data),
    );

    return response.data!;
  }

  Future<PageableDto<RecipeFileDto>> getRecipesIdFiles({
    required String recipeId,
    int? page,
    int? pageSize,
    OrderBy? orderBy,
    OrderDirection? orderDirection,
  }) async {
    final response = await get(
      url: '$_root/$recipeId/files',
      queryParameters: {
        'page': page,
        'pageSize': pageSize,
        'orderBy': orderBy?.name,
        'orderDirection': orderDirection?.name,
      },
      mapper: (data) => PageableDto.fromAPI<RecipeFileDto>(
        data,
        RecipeFileDto,
      ),
    );

    return response.data!;
  }

  Future<PageableDto<RecipePreviewDto>> getRecipesRandom({
    required Diet diet,
    Course? course,
    required int page,
    int? pageSize,
    OrderBy? orderBy,
    OrderDirection? orderDirection,
  }) async {
    final response = await get(
      url: '$_root/random',
      queryParameters: {
        'diet': diet.name,
        'course': course?.name,
        'page': page,
        'pageSize': pageSize,
        'orderBy': orderBy?.name,
        'orderDirection': orderDirection?.name,
      },
      mapper: (data) => PageableDto.fromAPI<RecipePreviewDto>(
        data,
        RecipePreviewDto,
      ),
    );

    return response.data!;
  }

  Future<PageableDto<RecipePreviewDto>> getRecipesSearch({
    required String query,
    required int page,
    int? pageSize,
    OrderBy? orderBy,
    OrderDirection? orderDirection,
  }) async {
    final response = await get(
      url: '$_root/search',
      queryParameters: {
        'query': query,
        'page': page,
        'pageSize': pageSize,
        'orderBy': orderBy?.name,
        'orderDirection': orderDirection?.name,
      },
      mapper: (data) => PageableDto.fromAPI<RecipePreviewDto>(
        data,
        RecipePreviewDto,
      ),
    );

    return response.data!;
  }

  Future<ApiResponse<String>> postRecipesId({required String id}) async {
    return await post<String>(url: '$_root/$id', mapper: (id) => id);
  }

  Future<ApiResponse<bool>> deleteRecipesId({required String id}) async {
    return await delete<bool>(url: '$_root/$id', mapper: (res) => res);
  }

  Future<ApiResponse<void>> putRecipesIdTransfer({
    required String id,
    required String newOwner,
  }) async {
    return await put(
      url: '$_root/$id/transfer',
      data: jsonEncode({'newOwner': newOwner}),
      mapper: ControllerApi.nullMapper,
    );
  }
}
