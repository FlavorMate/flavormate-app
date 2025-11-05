import 'package:dio/dio.dart';
import 'package:flavormate/core/apis/rest/p_dio_private.dart';
import 'package:flavormate/core/riverpod/pageable_state/p_pageable_state.dart';
import 'package:flavormate/data/datasources/features/recipe_draft_controller_api.dart';
import 'package:flavormate/data/models/features/recipe_draft/recipe_draft_file_dto.dart';
import 'package:flavormate/data/models/local/pageable_dto.dart';
import 'package:flavormate/data/models/shared/enums/order_by.dart';
import 'package:flavormate/data/models/shared/enums/order_direction.dart';
import 'package:flavormate/data/models/shared/models/api_response.dart';
import 'package:flavormate/data/repositories/features/recipe_drafts/p_rest_recipe_drafts.dart';
import 'package:flavormate/data/repositories/features/recipe_drafts/p_rest_recipe_drafts_id.dart';
import 'package:image_picker/image_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'p_rest_recipe_drafts_id_files.g.dart';

@riverpod
class PRestRecipeDraftsIdFiles extends _$PRestRecipeDraftsIdFiles {
  @override
  Future<PageableDto<RecipeDraftFileDto>> build({
    required String recipeDraftId,
    required String pageProviderId,
    int? pageSize,
    OrderBy? orderBy,
    OrderDirection? orderDirection,
  }) async {
    final page = ref.watch(pPageableStateProvider(pageProviderId));

    final dio = ref.watch(pDioPrivateProvider);

    final client = RecipeDraftControllerApi(dio);

    final response = await client.getRecipeDraftsIdFiles(
      recipeDraftId: recipeDraftId,
      page: page,
      pageSize: pageSize,
      orderBy: orderBy,
      orderDirection: orderDirection,
    );

    return response;
  }

  Future<ApiResponse<void>> addImage(XFile file) async {
    final dio = ref.watch(pDioPrivateProvider);

    final client = RecipeDraftControllerApi(dio);

    final bytes = await file.readAsBytes();

    final multipart = MultipartFile.fromBytes(
      bytes,
      contentType: DioMediaType.parse('application/octet-stream'),
    );

    final response = await client.postRecipeDraftsIdFiles(
      id: recipeDraftId,
      file: multipart,
    );

    ref.invalidateSelf();
    ref.invalidate(pRestRecipeDraftsIdProvider(recipeDraftId));

    return response;
  }

  Future<ApiResponse<void>> deleteImage(String id) async {
    final dio = ref.watch(pDioPrivateProvider);

    final client = RecipeDraftControllerApi(dio);

    final response = await client.deleteRecipeDraftsIdFiles(
      recipeDraftId: recipeDraftId,
      fileId: id,
    );

    ref.invalidateSelf();
    ref.invalidate(pRestRecipeDraftsIdProvider(recipeDraftId));

    return response;
  }
}
