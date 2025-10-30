import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flavormate/core/constants/api_constants.dart';
import 'package:flavormate/data/datasources/controller_api.dart';
import 'package:flavormate/data/models/features/recipe_draft/recipe_draft_dto.dart';
import 'package:flavormate/data/models/features/recipe_draft/recipe_draft_file_dto.dart';
import 'package:flavormate/data/models/local/pageable_dto.dart';
import 'package:flavormate/data/models/shared/enums/order_by.dart';
import 'package:flavormate/data/models/shared/enums/order_direction.dart';
import 'package:flavormate/data/models/shared/models/api_response.dart';
import 'package:flutter/foundation.dart';

@immutable
class RecipeDraftControllerApi extends ControllerApi {
  static const _root = ApiConstants.FeatureRecipeDrafts;

  const RecipeDraftControllerApi(super.dio);

  Future<PageableDto<RecipeDraftPreviewDto>> getRecipeDrafts({
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
      mapper: (data) => PageableDto.fromAPI<RecipeDraftPreviewDto>(
        data,
        RecipeDraftPreviewDto,
      ),
    );

    return response.data!;
  }

  Future<RecipeDraftFullDto> getRecipeDraftsId({
    required String id,
    required String language,
  }) async {
    final response = await get(
      url: '$_root/$id?language=$language',
      mapper: (data) => RecipeDraftFullDtoMapper.fromMap(data),
    );

    return response.data!;
  }

  Future<ApiResponse<void>> deleteRecipeDraftsId({required String id}) async {
    return await delete(url: '$_root/$id', mapper: ControllerApi.nullMapper);
  }

  Future<PageableDto<RecipeDraftFileDto>> getRecipeDraftsIdFiles({
    required String recipeDraftId,
    int? page,
    int? pageSize,
    OrderBy? orderBy,
    OrderDirection? orderDirection,
  }) async {
    final response = await get(
      url: '$_root/$recipeDraftId/files',
      queryParameters: {
        'page': page,
        'pageSize': pageSize,
        'orderBy': orderBy?.name,
        'orderDirection': orderDirection?.name,
      },
      mapper: (data) => PageableDto.fromAPI<RecipeDraftFileDto>(
        data,
        RecipeDraftFileDto,
      ),
    );

    return response.data!;
  }

  Future<ApiResponse<void>> deleteRecipeDraftsIdFiles({
    required String recipeDraftId,
    required String fileId,
  }) async {
    return await delete<void>(
      url: '$_root/$recipeDraftId/files/$fileId',
      mapper: ControllerApi.nullMapper,
    );
  }

  Future<ApiResponse<String>> postRecipeDrafts() async {
    return await post<String>(url: _root, mapper: (val) => val);
  }

  Future<ApiResponse<void>> postRecipeDraftsId(String id) async {
    return await post<void>(
      url: '$_root/$id',
      mapper: ControllerApi.nullMapper,
    );
  }

  Future<ApiResponse<void>> postRecipeDraftsIdFiles({
    required String id,
    required MultipartFile file,
  }) async {
    final data = FormData.fromMap({'file': file});
    return await post(
      url: '$_root/$id/files',
      data: data,
      mapper: ControllerApi.nullMapper,
    );
  }

  Future<ApiResponse<void>> putRecipeDraftsId({
    required String id,
    required Map<String, dynamic> form,
  }) async {
    return await put(url: '$_root/$id', data: jsonEncode(form), mapper: (_) {});
  }
}
