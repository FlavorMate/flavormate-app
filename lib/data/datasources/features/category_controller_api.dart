import 'package:flavormate/core/constants/api_constants.dart';
import 'package:flavormate/data/datasources/controller_api.dart';
import 'package:flavormate/data/models/features/categories/category_dto.dart';
import 'package:flavormate/data/models/features/recipes/recipe_dto.dart';
import 'package:flavormate/data/models/local/pageable_dto.dart';
import 'package:flavormate/data/models/shared/enums/order_by.dart';
import 'package:flavormate/data/models/shared/enums/order_direction.dart';
import 'package:flutter/foundation.dart';

@immutable
class CategoryControllerApi extends ControllerApi {
  static const _root = ApiConstants.FeatureCategories;

  const CategoryControllerApi(super.dio);

  Future<PageableDto<CategoryDto>> getCategories({
    required String language,
    int? page,
    int? pageSize,
    OrderBy? orderBy,
    OrderDirection? orderDirection,
  }) async {
    final response = await get(
      url: '$_root/',
      queryParameters: {
        'language': language,
        'page': page,
        'pageSize': pageSize,
        'orderBy': orderBy?.name,
        'orderDirection': orderDirection?.name,
      },
      mapper: (data) => PageableDto.fromAPI<CategoryDto>(
        data,
        CategoryDto,
      ),
    );

    return response.data!;
  }

  Future<CategoryDto> getCategoriesId({
    required String id,
    required String language,
  }) async {
    final response = await get(
      url: '$_root/$id',
      queryParameters: {'language': language},
      mapper: (data) => CategoryDtoMapper.fromMap(data),
    );

    return response.data!;
  }

  Future<PageableDto<RecipePreviewDto>> getCategoriesIdRecipes({
    required String categoryId,
    int? page,
    int? pageSize,
    OrderBy? orderBy,
    OrderDirection? orderDirection,
  }) async {
    final response = await get(
      url: '$_root/$categoryId/recipes',
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

  Future<PageableDto<CategoryDto>> getCategoriesSearch({
    required String query,
    required String language,
    required int page,
    int? pageSize,
    OrderBy? orderBy,
    OrderDirection? orderDirection,
  }) async {
    final response = await get(
      url: '$_root/search',
      queryParameters: {
        'query': query,
        'language': language,
        'page': page,
        'pageSize': pageSize,
        'orderBy': orderBy?.name,
        'orderDirection': orderDirection?.name,
      },
      mapper: (data) => PageableDto.fromAPI<CategoryDto>(
        data,
        CategoryDto,
      ),
    );

    return response.data!;
  }
}
