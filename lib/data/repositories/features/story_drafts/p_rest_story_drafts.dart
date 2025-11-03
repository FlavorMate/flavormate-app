import 'package:flavormate/core/apis/rest/p_dio_private.dart';
import 'package:flavormate/core/riverpod/pageable_state/p_pageable_state.dart';
import 'package:flavormate/data/datasources/features/story_draft_controller_api.dart';
import 'package:flavormate/data/models/features/story_drafts/story_draft_dto.dart';
import 'package:flavormate/data/models/local/pageable_dto.dart';
import 'package:flavormate/data/models/shared/enums/order_by.dart';
import 'package:flavormate/data/models/shared/enums/order_direction.dart';
import 'package:flavormate/data/models/shared/models/api_response.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'p_rest_story_drafts.g.dart';

@riverpod
class PRestStoryDrafts extends _$PRestStoryDrafts {
  @override
  Future<PageableDto<StoryDraftPreviewDto>> build(
    String pageId, {
    int? pageSize,
    OrderBy? orderBy,
    OrderDirection? orderDirection,
  }) async {
    final page = ref.watch(pPageableStateProvider(pageId));

    final dio = ref.watch(pDioPrivateProvider);

    final client = StoryDraftControllerApi(dio);

    final response = await client.getStoryDrafts(
      page: page,
      pageSize: pageSize,
      orderBy: orderBy,
      orderDirection: orderDirection,
    );

    return response;
  }

  Future<void> deleteDraft(String id) async {
    final dio = ref.watch(pDioPrivateProvider);

    final client = StoryDraftControllerApi(dio);

    await client.deleteStoryDraftsId(id: id);

    ref.invalidateSelf();
  }

  Future<ApiResponse<String>> createDraft() async {
    final dio = ref.watch(pDioPrivateProvider);

    final client = StoryDraftControllerApi(dio);

    final response = await client.postStoryDrafts();

    ref.invalidateSelf();

    return response;
  }
}
