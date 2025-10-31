import 'package:flavormate/core/apis/rest/p_dio_private.dart';
import 'package:flavormate/core/riverpod/pageable_state/p_pageable_state.dart';
import 'package:flavormate/data/datasources/features/highlight_controller_api.dart';
import 'package:flavormate/data/models/features/highlights/highlight_dto.dart';
import 'package:flavormate/data/models/local/pageable_dto.dart';
import 'package:flavormate/data/models/shared/enums/order_by.dart';
import 'package:flavormate/data/models/shared/enums/order_direction.dart';
import 'package:flavormate/data/repositories/features/accounts/p_rest_accounts_self.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'p_rest_highlights.g.dart';

@riverpod
class PRestHighlights extends _$PRestHighlights {
  @override
  Future<PageableDto<HighlightDto>> build(
    String pageId, {
    int? pageSize,
    OrderBy? orderBy,
    OrderDirection? orderDirection,
  }) async {
    final page = ref.watch(pPageableStateProvider(pageId));

    final self = await ref.watch(
      pRestAccountsSelfProvider.selectAsync((acc) => acc.diet),
    );

    final dio = ref.watch(pDioPrivateProvider);

    final client = HighlightControllerApi(dio);

    final response = await client.getHighlights(
      diet: self,
      page: page,
      pageSize: pageSize,
      orderBy: orderBy,
      orderDirection: orderDirection,
    );

    return response;
  }
}
