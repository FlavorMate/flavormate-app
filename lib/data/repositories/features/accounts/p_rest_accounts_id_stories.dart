import 'package:flavormate/core/apis/rest/p_dio_private.dart';
import 'package:flavormate/core/riverpod/pageable_state/p_pageable_state.dart';
import 'package:flavormate/data/datasources/features/account_controller_api.dart';
import 'package:flavormate/data/models/features/stories/story_dto.dart';
import 'package:flavormate/data/models/local/pageable_dto.dart';
import 'package:flavormate/data/models/shared/enums/order_by.dart';
import 'package:flavormate/data/models/shared/enums/order_direction.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'p_rest_accounts_id_stories.g.dart';

@riverpod
class PRestAccountsIdStories extends _$PRestAccountsIdStories {
  @override
  Future<PageableDto<StoryPreviewDto>> build({
    required String accountId,
    required String pageProviderId,
    int? pageSize,
    OrderBy? orderBy,
    OrderDirection? orderDirection,
  }) async {
    final dio = ref.watch(pDioPrivateProvider);

    final page = ref.watch(pPageableStateProvider(pageProviderId));

    final client = AccountControllerApi(dio);

    final response = await client.getAccountsIdStories(
      accountId: accountId,
      page: page,
      pageSize: pageSize,
      orderBy: orderBy,
      orderDirection: orderDirection,
    );

    return response;
  }
}
