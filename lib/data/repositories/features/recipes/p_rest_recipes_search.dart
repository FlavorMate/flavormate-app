import 'package:flavormate/core/apis/rest/p_dio_private.dart';
import 'package:flavormate/core/riverpod/pageable_state/p_pageable_state.dart';
import 'package:flavormate/core/riverpod/search_state/p_search_state.dart';
import 'package:flavormate/data/datasources/features/recipe_controller_api.dart';
import 'package:flavormate/data/models/features/recipes/recipe_dto.dart';
import 'package:flavormate/data/models/local/pageable_dto.dart';
import 'package:flavormate/data/models/shared/enums/order_by.dart';
import 'package:flavormate/data/models/shared/enums/order_direction.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'p_rest_recipes_search.g.dart';

@riverpod
class PRestRecipesSearch extends _$PRestRecipesSearch {
  @override
  Future<PageableDto<RecipePreviewDto>> build({
    required String queryProviderId,
    required String pageProviderId,
    int? pageSize,
    OrderBy? orderBy,
    OrderDirection? orderDirection,
  }) async {
    final dio = ref.watch(pDioPrivateProvider);

    final page = ref.watch(pPageableStateProvider(pageProviderId));

    final query = ref.watch(pSearchStateProvider(queryProviderId));

    final client = RecipeControllerApi(dio);

    final response = await client.getRecipesSearch(
      query: query,
      page: page,
      pageSize: pageSize,
      orderBy: orderBy,
      orderDirection: orderDirection,
    );

    return response;
  }
}
