import 'package:flavormate/core/constants/api_constants.dart';
import 'package:flavormate/data/datasources/controller_api.dart';
import 'package:flavormate/data/models/features/recipes/recipe_dto.dart';
import 'package:flavormate/data/models/features/tags/tag_dto.dart';
import 'package:flavormate/data/models/local/pageable_dto.dart';
import 'package:flavormate/data/models/shared/enums/order_by.dart';
import 'package:flavormate/data/models/shared/enums/order_direction.dart';
import 'package:flutter/foundation.dart';

@immutable
class TagControllerApi extends ControllerApi {
  static const _root = ApiConstants.FeatureTags;

  const TagControllerApi(super.dio);

  Future<PageableDto<TagDto>> getTags({
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
      mapper: (data) => PageableDto.fromAPI<TagDto>(
        data,
        TagDto,
      ),
    );

    return response.data!;
  }

  Future<TagDto> getTagsId({required String id}) async {
    final response = await get(
      url: '$_root/$id',
      mapper: (data) => TagDtoMapper.fromMap(data),
    );

    return response.data!;
  }

  Future<PageableDto<RecipePreviewDto>> getTagsIdRecipes({
    required String tagId,
    int? page,
    int? pageSize,
    OrderBy? orderBy,
    OrderDirection? orderDirection,
  }) async {
    final response = await get(
      url: '$_root/$tagId/recipes',
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

  Future<PageableDto<TagDto>> getTagsSearch({
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
      mapper: (data) => PageableDto.fromAPI<TagDto>(
        data,
        TagDto,
      ),
    );

    return response.data!;
  }
}
