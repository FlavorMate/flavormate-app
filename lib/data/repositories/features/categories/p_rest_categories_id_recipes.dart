import 'package:flavormate/core/apis/rest/p_dio_private.dart';
import 'package:flavormate/core/riverpod/pageable_state/p_pageable_state.dart';
import 'package:flavormate/data/datasources/features/category_controller_api.dart';
import 'package:flavormate/data/models/features/recipes/recipe_dto.dart';
import 'package:flavormate/data/models/local/pageable_dto.dart';
import 'package:flavormate/data/models/shared/enums/order_by.dart';
import 'package:flavormate/data/models/shared/enums/order_direction.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'p_rest_categories_id_recipes.g.dart';

@riverpod
class PRestCategoriesIdRecipes extends _$PRestCategoriesIdRecipes {
  @override
  Future<PageableDto<RecipePreviewDto>> build({
    required String categoryId,
    required String pageProviderId,
    int? pageSize,
    OrderBy? orderBy,
    OrderDirection? orderDirection,
  }) async {
    final page = ref.watch(pPageableStateProvider(pageProviderId));

    final dio = ref.watch(pDioPrivateProvider);

    final client = CategoryControllerApi(dio);

    final response = await client.getCategoriesIdRecipes(
      categoryId: categoryId,
      page: page,
      pageSize: pageSize,
      orderBy: orderBy,
      orderDirection: orderDirection,
    );

    return response;
  }
}
