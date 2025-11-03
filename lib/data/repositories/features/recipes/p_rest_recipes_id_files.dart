import 'package:flavormate/core/apis/rest/p_dio_private.dart';
import 'package:flavormate/core/riverpod/pageable_state/p_pageable_state.dart';
import 'package:flavormate/data/datasources/features/recipe_controller_api.dart';
import 'package:flavormate/data/models/features/recipes/recipe_file_dto.dart';
import 'package:flavormate/data/models/local/pageable_dto.dart';
import 'package:flavormate/data/models/shared/enums/order_by.dart';
import 'package:flavormate/data/models/shared/enums/order_direction.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'p_rest_recipes_id_files.g.dart';

@riverpod
class PRestRecipesIdFiles extends _$PRestRecipesIdFiles {
  @override
  Future<PageableDto<RecipeFileDto>> build({
    required String recipeId,
    required String pageProviderId,
    int? pageSize,
    OrderBy? orderBy,
    OrderDirection? orderDirection,
  }) async {
    final page = ref.watch(pPageableStateProvider(pageProviderId));

    final dio = ref.watch(pDioPrivateProvider);

    final client = RecipeControllerApi(dio);

    final response = await client.getRecipesIdFiles(
      recipeId: recipeId,
      page: page,
      pageSize: pageSize,
      orderBy: orderBy,
      orderDirection: orderDirection,
    );

    return response;
  }
}
