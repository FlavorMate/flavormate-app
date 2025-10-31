import 'package:flavormate/core/constants/api_constants.dart';
import 'package:flavormate/data/datasources/controller_api.dart';
import 'package:flavormate/data/models/features/stories/story_dto.dart';
import 'package:flavormate/data/models/local/pageable_dto.dart';
import 'package:flavormate/data/models/shared/enums/order_by.dart';
import 'package:flavormate/data/models/shared/enums/order_direction.dart';
import 'package:flavormate/data/models/shared/models/api_response.dart';
import 'package:flutter/foundation.dart';

@immutable
class StoryControllerApi extends ControllerApi {
  static const _root = ApiConstants.FeatureStories;

  const StoryControllerApi(super.dio);

  Future<PageableDto<StoryPreviewDto>> getStories({
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
      mapper: (data) => PageableDto.fromAPI<StoryPreviewDto>(
        data,
        StoryPreviewDto,
      ),
    );

    return response.data!;
  }

  Future<PageableDto<StoryPreviewDto>> getStoriesSearch({
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
      mapper: (data) => PageableDto.fromAPI<StoryPreviewDto>(
        data,
        StoryPreviewDto,
      ),
    );

    return response.data!;
  }

  Future<StoryFullDto> getStoriesId({
    required String id,
  }) async {
    final response = await get(
      url: '$_root/$id',
      mapper: (data) => StoryFullDtoMapper.fromMap(data),
    );

    return response.data!;
  }

  Future<ApiResponse<void>> deleteStoriesId({
    required String id,
  }) async {
    return await delete(url: '$_root/$id', mapper: ControllerApi.nullMapper);
  }

  Future<ApiResponse<String>> postStoriesId({required String id}) async {
    return await post<String>(url: '$_root/$id', mapper: (val) => val);
  }
}
