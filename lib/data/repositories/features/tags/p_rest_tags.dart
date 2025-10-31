import 'package:flavormate/core/apis/rest/p_dio_private.dart';
import 'package:flavormate/core/riverpod/pageable_state/p_pageable_state.dart';
import 'package:flavormate/data/datasources/features/tag_controller_api.dart';
import 'package:flavormate/data/models/features/tags/tag_dto.dart';
import 'package:flavormate/data/models/local/pageable_dto.dart';
import 'package:flavormate/data/models/shared/enums/order_by.dart';
import 'package:flavormate/data/models/shared/enums/order_direction.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'p_rest_tags.g.dart';

@riverpod
class PRestTags extends _$PRestTags {
  @override
  Future<PageableDto<TagDto>> build(
    String pageId, {
    int? pageSize,
    OrderBy? orderBy,
    OrderDirection? orderDirection,
  }) async {
    final page = ref.watch(pPageableStateProvider(pageId));

    final dio = ref.watch(pDioPrivateProvider);

    final client = TagControllerApi(dio);

    final response = await client.getTags(
      page: page,
      pageSize: pageSize,
      orderBy: orderBy,
      orderDirection: orderDirection,
    );

    return response;
  }
}
