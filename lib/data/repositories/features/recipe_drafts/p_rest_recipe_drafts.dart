import 'package:flavormate/core/apis/rest/p_dio_private.dart';
import 'package:flavormate/core/riverpod/pageable_state/p_pageable_state.dart';
import 'package:flavormate/data/datasources/extensions/scrape_controller_api.dart';
import 'package:flavormate/data/datasources/features/recipe_draft_controller_api.dart';
import 'package:flavormate/data/models/features/recipe_draft/recipe_draft_dto.dart';
import 'package:flavormate/data/models/local/pageable_dto.dart';
import 'package:flavormate/data/models/shared/enums/order_by.dart';
import 'package:flavormate/data/models/shared/enums/order_direction.dart';
import 'package:flavormate/data/models/shared/models/api_response.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'p_rest_recipe_drafts.g.dart';

@riverpod
class PRestRecipeDrafts extends _$PRestRecipeDrafts {
  @override
  Future<PageableDto<RecipeDraftPreviewDto>> build(
    String pageId, {
    int? pageSize,
    OrderBy? orderBy,
    OrderDirection? orderDirection,
  }) async {
    final page = ref.watch(pPageableStateProvider(pageId));

    final dio = ref.watch(pDioPrivateProvider);

    final client = RecipeDraftControllerApi(dio);

    final response = await client.getRecipeDrafts(
      page: page,
      pageSize: pageSize,
      orderBy: orderBy,
      orderDirection: orderDirection,
    );

    return response;
  }

  Future<ApiResponse<String>> createDraft() async {
    final dio = ref.watch(pDioPrivateProvider);

    final client = RecipeDraftControllerApi(dio);

    final response = await client.postRecipeDrafts();

    ref.invalidateSelf();

    return response;
  }

  Future<ApiResponse<String>> scrape(String url) async {
    final dio = ref.watch(pDioPrivateProvider);

    final client = ScrapeControllerApi(dio);

    final response = await client.scrape(url: url);

    if (!response.hasError) {
      ref.invalidateSelf();
    }

    return response;
  }

  Future<ApiResponse<void>> deleteDraft(String id) async {
    final dio = ref.watch(pDioPrivateProvider);

    final client = RecipeDraftControllerApi(dio);

    final response = await client.deleteRecipeDraftsId(id: id);

    ref.invalidateSelf();

    return response;
  }
}
