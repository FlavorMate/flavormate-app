import 'dart:convert';

import 'package:flavormate/core/constants/api_constants.dart';
import 'package:flavormate/data/datasources/controller_api.dart';
import 'package:flavormate/data/models/features/story_drafts/story_draft_dto.dart';
import 'package:flavormate/data/models/local/pageable_dto.dart';
import 'package:flavormate/data/models/shared/enums/order_by.dart';
import 'package:flavormate/data/models/shared/enums/order_direction.dart';
import 'package:flavormate/data/models/shared/models/api_response.dart';
import 'package:flutter/foundation.dart';

@immutable
class StoryDraftControllerApi extends ControllerApi {
  static const _root = ApiConstants.FeatureStoryDrafts;

  const StoryDraftControllerApi(super.dio);

  Future<PageableDto<StoryDraftPreviewDto>> getStoryDrafts({
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
      mapper: (data) => PageableDto.fromAPI<StoryDraftPreviewDto>(
        data,
        StoryDraftPreviewDto,
      ),
    );

    return response.data!;
  }

  Future<StoryDraftFullDto> getStoryDraftsId({required String id}) async {
    final response = await get(
      url: '$_root/$id',
      mapper: (data) => StoryDraftFullDtoMapper.fromMap(data),
    );

    return response.data!;
  }

  Future<ApiResponse<void>> deleteStoryDraftsId({required String id}) async {
    return await delete(url: '$_root/$id', mapper: ControllerApi.nullMapper);
  }

  Future<ApiResponse<String>> postStoryDrafts() async {
    return await post<String>(url: _root, mapper: (val) => val);
  }

  Future<ApiResponse<void>> putStoryDraftsId({
    required String id,
    required Map<String, dynamic> form,
  }) async {
    return await put(
      url: '$_root/$id',
      data: jsonEncode(form),
      mapper: ControllerApi.nullMapper,
    );
  }

  Future<ApiResponse<String>> postStoryDraftsId({required String id}) async {
    return await post(url: '$_root/$id', mapper: (val) => val);
  }
}
