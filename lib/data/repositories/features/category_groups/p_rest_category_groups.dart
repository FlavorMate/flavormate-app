import 'package:flavormate/core/apis/rest/p_dio_private.dart';
import 'package:flavormate/core/riverpod/pageable_state/p_pageable_state.dart';
import 'package:flavormate/core/utils/u_localizations.dart';
import 'package:flavormate/data/datasources/features/category_group_controller_api.dart';
import 'package:flavormate/data/models/features/category_drafts/category_group_dto.dart';
import 'package:flavormate/data/models/local/pageable_dto.dart';
import 'package:flavormate/data/models/shared/enums/order_by.dart';
import 'package:flavormate/data/models/shared/enums/order_direction.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'p_rest_category_groups.g.dart';

@riverpod
class PRestCategoryGroups extends _$PRestCategoryGroups {
  @override
  Future<PageableDto<CategoryGroupDto>> build({
    required String pageProviderId,
    int? pageSize,
    OrderBy? orderBy,
    OrderDirection? orderDirection,
  }) async {
    final page = ref.watch(pPageableStateProvider(pageProviderId));

    final language = currentLocalization().languageCode;

    final dio = ref.watch(pDioPrivateProvider);

    final client = CategoryGroupControllerApi(dio);

    final response = await client.getCategoryGroups(
      language: language,
      page: page,
      pageSize: pageSize,
      orderBy: orderBy,
      orderDirection: orderDirection,
    );

    return response;
  }
}
